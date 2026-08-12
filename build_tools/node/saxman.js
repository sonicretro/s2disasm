// Saxman compression.
//
// 'authentic' is a port of 'lz_comp2/LZSS.c' from
// https://github.com/Clownacy/p2bin (Haruhiko Okumura's LZSS.C, as modified by
// Clownacy for Sonic 2's Saxman variant). It must be bug-for-bug identical to
// the C version, or the ROM will not be byte-perfect with the original release.
//
// 'optimised' is a port of 'saxman.c' and the shortest-path compressor in
// 'clownlzss.h', from https://github.com/Clownacy/clownlzss.


const N = 4096;      // size of ring buffer
const F = 18;        // upper limit for match_length
const THRESHOLD = 2; // encode string into position and length if match_length is greater than this
const NIL = N;       // index for root of binary search trees

const EOF = -1;

// A direct translation of 'Encode' from LZSS.c.
function encodeAuthentic(input) {
	const text_buf = new Uint8Array(N + F - 1); // ring buffer of size N, with extra F-1 bytes to facilitate string comparison
	const lson = new Int32Array(N + 1), rson = new Int32Array(N + 257), dad = new Int32Array(N + 1); // left & right children & parents
	let match_position = 0, match_length = 0; // of longest match; set by InsertNode
	let input_position = 0;
	const output = [];

	function ReadByte() {
		return input_position === input.length ? EOF : input[input_position++];
	}

	function InitTree() {
		for (let i = N + 1; i <= N + 256; i++) rson[i] = NIL;
		for (let i = 0; i < N; i++) dad[i] = NIL;
	}

	function InsertNode(r) {
		let i, p, cmp;

		cmp = 1; const key = r; p = N + 1 + text_buf[key];
		rson[r] = lson[r] = NIL; match_length = 0;
		for (;;) {
			if (cmp >= 0) {
				if (rson[p] !== NIL) p = rson[p];
				else { rson[p] = r; dad[r] = p; return; }
			} else {
				if (lson[p] !== NIL) p = lson[p];
				else { lson[p] = r; dad[r] = p; return; }
			}
			for (i = 1; i < F; i++)
				if ((cmp = text_buf[key + i] - text_buf[p + i]) !== 0) break;
			if (i > match_length) {
				match_position = p;
				if ((match_length = i) >= F) break;
			}
		}
		dad[r] = dad[p]; lson[r] = lson[p]; rson[r] = rson[p];
		dad[lson[p]] = r; dad[rson[p]] = r;
		if (rson[dad[p]] === p) rson[dad[p]] = r;
		else                    lson[dad[p]] = r;
		dad[p] = NIL; // remove p
	}

	function DeleteNode(p) {
		let q;

		if (dad[p] === NIL) return; // not in tree
		if (rson[p] === NIL) q = lson[p];
		else if (lson[p] === NIL) q = rson[p];
		else {
			q = lson[p];
			if (rson[q] !== NIL) {
				do { q = rson[q]; } while (rson[q] !== NIL);
				rson[dad[q]] = lson[q]; dad[lson[q]] = dad[q];
				lson[q] = lson[p]; dad[lson[p]] = q;
			}
			rson[q] = rson[p]; dad[rson[p]] = q;
		}
		dad[q] = dad[p];
		if (rson[dad[p]] === p) rson[dad[p]] = q; else lson[dad[p]] = q;
		dad[p] = NIL;
	}

	let i, c, len, r, s, last_match_length, code_buf_ptr;
	const code_buf = new Uint8Array(17);
	let mask;

	InitTree();
	code_buf[0] = 0;
	code_buf_ptr = mask = 1;
	s = 0; r = N - F;
	for (i = s; i < r; i++) text_buf[i] = 0;
	for (len = 0; len < F && (c = ReadByte()) !== EOF; len++)
		text_buf[r + len] = c;
	if (len === 0) return Buffer.alloc(0); // text of size zero
	for (i = 1; i <= F; i++) InsertNode(r - i);
	InsertNode(r);
	do {
		if (match_length > len) match_length = len;
		if (match_length <= THRESHOLD) {
			match_length = 1; // Not long enough match. Send one byte.
			code_buf[0] |= mask;
			code_buf[code_buf_ptr++] = text_buf[r];
		} else {
			code_buf[code_buf_ptr++] = match_position & 0xFF;
			code_buf[code_buf_ptr++] = ((match_position >> 4) & 0xF0) | (match_length - (THRESHOLD + 1));
		}
		if ((mask = (mask << 1) & 0xFF) === 0) { // 'mask' is an unsigned char in the C version.
			for (i = 0; i < code_buf_ptr; i++) output.push(code_buf[i]);
			code_buf[0] = 0; code_buf_ptr = mask = 1;
		}
		last_match_length = match_length;
		for (i = 0; i < last_match_length && (c = ReadByte()) !== EOF; i++) {
			DeleteNode(s);
			text_buf[s] = c;
			if (s < F - 1) text_buf[s + N] = c;
			s = (s + 1) & (N - 1); r = (r + 1) & (N - 1);
			InsertNode(r);
		}
		while (i++ < last_match_length) {
			DeleteNode(s);
			s = (s + 1) & (N - 1); r = (r + 1) & (N - 1);
			if (--len) InsertNode(r);
		}
	} while (len > 0);
	if (code_buf_ptr > 1)
		for (i = 0; i < code_buf_ptr; i++) output.push(code_buf[i]);

	return Buffer.from(output);
}

function withSizeHeader(compressed) {
	const header = Buffer.alloc(2);
	header.writeUInt16LE(compressed.length & 0xFFFF, 0);
	return Buffer.concat([header, compressed]);
}
const MAX_MATCH_LENGTH = 0x12;
const MAX_MATCH_DISTANCE = 0x1000;
const LITERAL_COST = 1 + 8; // Descriptor bit, byte
const MATCH_COST = 1 + 16;  // Descriptor bit, offset/length bits
const TOTAL_DESCRIPTOR_BITS = 8;

const DUMMY = -1;
const MAXIMUM_COST = Number.MAX_SAFE_INTEGER;

// A translation of 'CLOWNLZSS_MAKE_COMPRESSION_FUNCTION' from clownlzss.h, with
// the parameters that Saxman uses. Rather than compressing greedily, this finds
// the combination of matches that produces the smallest output, by treating the
// possible matches as a graph and finding the shortest path through it.
function compressData(data, callbacks) {
	const total_values = data.length;

	// String list stuff.
	const next = new Int32Array(MAX_MATCH_DISTANCE + 0x100).fill(DUMMY);
	const prev = new Int32Array(MAX_MATCH_DISTANCE).fill(DUMMY);
	const bytes = new Int32Array(MAX_MATCH_DISTANCE);

	// The edges of the LZSS graph.
	const cost = new Float64Array(total_values + 1).fill(MAXIMUM_COST); // +1 for the end-node
	const previous_node_index = new Int32Array(total_values + 1).fill(DUMMY);
	const next_node_index = new Int32Array(total_values + 1).fill(DUMMY);
	const match_length = new Int32Array(total_values + 1);
	const match_offset = new Int32Array(total_values + 1);

	cost[0] = 0;

	// Advance through the data one step at a time.
	for (let i = 0; i < total_values; ++i) {
		const string_list_head = MAX_MATCH_DISTANCE + data[i];
		const current_string = i % MAX_MATCH_DISTANCE;

		// Saxman can encode runs of zeroes as matches that read from the part of
		// the sound driver's RAM that is always zero.
		if (i < 0x1000) {
			const max_read_ahead = Math.min(0x12, total_values - i);

			for (let j = 0; j < max_read_ahead && data[i + j] === 0; ++j)
				// Runs shorter than three bytes cannot be encoded as matches.
				if (j + 1 >= 3 && cost[i + j + 1] > cost[i] + MATCH_COST) {
					cost[i + j + 1] = cost[i] + MATCH_COST;
					previous_node_index[i + j + 1] = i;
					match_length[i + j + 1] = j + 1;
					match_offset[i + j + 1] = 0xFFF;
				}
		}

		// 'string_list_head' points to a linked-list of strings in the LZSS sliding window that match at least
		// one byte with the current string: iterate over it and generate every possible match for this string.
		for (let match_string = next[string_list_head]; match_string !== DUMMY; match_string = next[match_string]) {
			const match_start = bytes[match_string];
			const maximum_length = Math.min(MAX_MATCH_LENGTH, total_values - i);

			for (let j = 1; j < maximum_length; ++j) {
				if (data[i + j] !== data[match_start + j]) {
					// No match: give up on the current run.
					break;
				} else if (j + 1 >= 3) {
					// Figure out if the cost is lower than that of any other runs that end at the same value as this one.
					if (cost[i + j + 1] > cost[i] + MATCH_COST) {
						// Record this new best run in the graph edge assigned to the value at the end of the run.
						cost[i + j + 1] = cost[i] + MATCH_COST;
						previous_node_index[i + j + 1] = i;
						match_length[i + j + 1] = j + 1;
						match_offset[i + j + 1] = match_start;
					}
				}
			}
		}

		// If a literal match is more efficient than all runs assigned to this value, then use that instead.
		if (cost[i + 1] >= cost[i] + LITERAL_COST) {
			cost[i + 1] = cost[i] + LITERAL_COST;
			previous_node_index[i + 1] = i;
			match_length[i + 1] = 0;
		}

		// Replace the oldest string in the list with the new string, since it's about to be pushed out of the LZSS sliding window.

		// Detach the old node in this slot.
		if (prev[current_string] !== DUMMY) {
			next[prev[current_string]] = next[current_string];

			if (next[current_string] !== DUMMY)
				prev[next[current_string]] = prev[current_string];
		}

		// Replace the old node with this new one, and insert it at the start of its matching list.
		bytes[current_string] = i;
		prev[current_string] = string_list_head;
		next[current_string] = next[string_list_head];

		if (next[string_list_head] !== DUMMY)
			prev[next[string_list_head]] = current_string;

		next[string_list_head] = current_string;
	}

	// At this point, the edges will have formed a shortest-path from the start to the end:
	// You just have to start at the last edge, and follow it backwards all the way to the start.

	// Mark start/end nodes for the following loops.
	previous_node_index[0] = DUMMY;
	next_node_index[total_values] = DUMMY;

	// Reverse the direction of the edges, so we can parse the LZSS graph from start to end.
	for (let i = total_values; previous_node_index[i] !== DUMMY; i = previous_node_index[i])
		next_node_index[previous_node_index[i]] = i;

	// Go through our now-complete LZSS graph, and output the optimally-compressed file.
	for (let i = 0; next_node_index[i] !== DUMMY; i = next_node_index[i]) {
		const next_index = next_node_index[i];
		const length = match_length[next_index];
		const offset = match_offset[next_index];

		if (length === 0)
			callbacks.literal(data[i]);
		else
			callbacks.match(length, offset);
	}
}

// A translation of 'SaxmanCompressStream' from clownlzss/saxman.c.
function encodeOptimised(data) {
	const output = [];
	let match_buffer = [];
	let descriptor = 0;
	let descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;

	function flushData() {
		output.push(descriptor);
		output.push(...match_buffer);
	}

	function putDescriptorBit(bit) {
		if (descriptor_bits_remaining === 0) {
			flushData();

			descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;
			match_buffer = [];
		}

		--descriptor_bits_remaining;

		descriptor >>= 1;

		if (bit)
			descriptor |= 1 << (TOTAL_DESCRIPTOR_BITS - 1);
	}

	compressData(data, {
		literal: function (value) {
			putDescriptorBit(1);
			match_buffer.push(value);
		},
		match: function (length, offset) {
			putDescriptorBit(0);
			match_buffer.push((offset - 0x12) & 0xFF);
			match_buffer.push((((offset - 0x12) & 0xF00) >> 4) | (length - 3));
		},
	});

	descriptor >>= descriptor_bits_remaining;
	flushData();

	return Buffer.from(output);
}

// The compressor that the original game used, complete with its bugs.
function compressAuthentic(data, header) {
	const compressed = encodeAuthentic(data);
	return header ? withSizeHeader(compressed) : compressed;
}

// A modern compressor which produces smaller data, at the cost of accuracy.
function compressOptimised(data, header) {
	const compressed = encodeOptimised(data);
	return header ? withSizeHeader(compressed) : compressed;
}

module.exports = {
	compressAuthentic: compressAuthentic,
	compressOptimised: compressOptimised,
};
