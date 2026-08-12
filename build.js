#!/usr/bin/env node

////////////////
// Settings ////
////////////////

// Set this to true to use a better compression algorithm for the sound driver.
// Having this set to false will use an inferior compression algorithm that
// results in an accurate ROM being produced.
const improved_sound_driver_compression = false;

// These describe the Saxman decompression buffer in the sound driver.
const music_buffer_address = 0x1380; // Should always match zMusicData in s2.sounddriver.asm.
const music_buffer_size = 0x7C0;     // Should always be zStack minus 0x40.

///////////////////////
// End of settings ////
///////////////////////

/////////////////
// Utilities ////
/////////////////

const fs = require('fs');
const os = require('os');

const common = require('./build_tools/node/common.js');
const saxman = require('./build_tools/node/saxman.js');

// Deletes the temporary files that the song assemblies leave behind. Log files
// are kept, since the build refers the user to them when something goes wrong.
function cleanUpTemporaryFiles() {
	for (const filename of fs.readdirSync('.'))
		if (/^song[0-9]+\.(asm|p|lst|bin)$/.test(filename))
			fs.rmSync(filename, {force: true});
}

// Runs the given tasks, several at a time. Songs are assembled in their own
// processes, so there is no reason not to use every processor that we have.
// Returns whether every task succeeded: the first failure stops the remaining
// tasks from being started, but the running ones are waited for, so that they
// cannot litter the repository with temporary files as they exit.
async function runInParallel(tasks) {
	const total_workers = Math.min(os.availableParallelism(), tasks.length);
	const workers = [];

	let succeeded = true;

	for (let worker_index = 0; worker_index < total_workers; worker_index++)
		workers.push((async function (worker_index) {
			// Every worker needs its own temporary file names, so that the workers
			// running alongside it do not clobber them.
			for (let task_index = worker_index; succeeded && task_index < tasks.length; task_index += total_workers)
				if (!await tasks[task_index]('song' + worker_index))
					succeeded = false;
		})(worker_index));

	await Promise.all(workers);

	return succeeded;
}

async function generateMusicData() {
	const compressed_song_list_filename = 'sound/music/list of compressed songs.txt';

	// Determine which songs are going to be compressed.
	const compressed_songs = new Set(fs.readFileSync(compressed_song_list_filename, 'utf8').split('\n').map((line) => line.replace(/\r$/, '')).filter((line) => line !== ''));

	const custom_hashes = {
		improved_sound_driver_compression: improved_sound_driver_compression,
		music_buffer_address: music_buffer_address,
		music_buffer_size: music_buffer_size,
		compressed_song_list: common.hashFile(compressed_song_list_filename),
		smps2asm: common.hashFile('sound/_smps2asm_inc.asm'),
	};

	const tasks = [];

	for (const filename_stem of common.getDirectoryContentsChanged('sound/music', '.asm', ['.sax', '.inc'], custom_hashes)) {
		const is_compressed = compressed_songs.has(filename_stem);

		const inc_file_path = 'sound/music/generated/' + filename_stem + '.inc';

		// Generate an '.inc' file for the song, which communicates to the assembler the song's file path as well as whether it is compressed or not.
		if (is_compressed)
			fs.writeFileSync(inc_file_path,
				'.is_compressed = TRUE\n'
				+ '\tbinclude "sound/music/generated/' + filename_stem + '.sax"\n');
		else
			fs.writeFileSync(inc_file_path,
				'.is_compressed = FALSE\n'
				+ '\tinclude "sound/music/' + filename_stem + '.asm"\n');

		// If the song is compressed then compress it!
		if (is_compressed)
			tasks.push(async function (temporary_filename_stem) {
			const sax_file_path = 'sound/music/generated/' + filename_stem + '.sax';

			console.log("Reassembling song '" + filename_stem + ".asm'...");

			// To begin with, we'll create a wrapper ASM file to set the environment
			// in which to assemble the lone song file. Notably, this environment
			// includes SMPS2ASM and begins the song at address 0x1380 (the address
			// of the Saxman decompression buffer in Z80 RAM).
			fs.writeFileSync(temporary_filename_stem + '.asm',
				  '\tCPU 68000\n'
				+ '\tpadding off\n'
				+ '\n'
				+ 'z80_ptr function x,(x)<<8&$FF00|(x)>>8&$00FF\n'
				+ '\n'
				+ 'FixMusicAndSFXDataBugs = 0\n'
				+ 'SonicDriverVer = 2\n'
				+ '\tinclude "sound/_smps2asm_inc.asm"\n'
				+ '\n'
				+ '\tphase $' + music_buffer_address.toString(16).toUpperCase() + '\n'
				+ '\tinclude "sound/music/' + filename_stem + '.asm"\n'
				+ '\tdephase\n'
				+ '\n'
				+ '\tif *>$' + music_buffer_size.toString(16).toUpperCase() + '\n'
				+ '\t\terror "This song is too big and will overflow the decompression buffer! It should be uncompressed instead!"\n'
				+ '\tendif\n');

			// Assemble the song to an uncompressed binary.
			const [message_printed, abort] = await common.assembleFile(temporary_filename_stem + '.asm', temporary_filename_stem + '.bin', [], {}, false);

			// We can get rid of this wrapper ASM file now.
			fs.rmSync(temporary_filename_stem + '.asm', {force: true});

			if (message_printed)
				common.handleFailure(true, false);

			if (abort)
				return false;

			// Now that we have an assembled song binary, compress it.
			const song = fs.readFileSync(temporary_filename_stem + '.bin');
			fs.writeFileSync(sax_file_path, improved_sound_driver_compression ? saxman.compressOptimised(song, true) : saxman.compressAuthentic(song, true));

			// Remove junk files from the assembly process.
			fs.rmSync(temporary_filename_stem + '.bin', {force: true});

			return true;
			});
	}

	// Give up if any of the songs failed to assemble.
	if (!await runInParallel(tasks))
		common.handleFailure(false, true);
}

function amendSoundDriverSize() {
	// Correct the compressed sound driver size, which we couldn't do until p2bin had been ran.
	let comp_z80_size, movewZ80CompSize;

	for (const line of fs.readFileSync('s2.h', 'utf8').split('\n')) {
		const comp_z80_size_match = /comp_z80_size.*?(0x[0-9A-Fa-f]+)/.exec(line);

		if (comp_z80_size_match !== null)
			comp_z80_size = parseInt(comp_z80_size_match[1], 16);

		const movewZ80CompSize_match = /movewZ80CompSize.*?(0x[0-9A-Fa-f]+)/.exec(line);

		if (movewZ80CompSize_match !== null)
			movewZ80CompSize = parseInt(movewZ80CompSize_match[1], 16);
	}

	if (comp_z80_size !== undefined && movewZ80CompSize !== undefined) {
		const rom = fs.readFileSync('s2built.bin');
		rom.writeUInt16BE(comp_z80_size, movewZ80CompSize + 2);
		fs.writeFileSync('s2built.bin', rom);
	}

	// Remove the header file, since we no longer need it.
	fs.rmSync('s2.h', {force: true});
}

////////////////////////
// End of utilities ////
////////////////////////

///////////////////////////////////////
// Actual build script begins here ////
///////////////////////////////////////

async function build() {
	// The song assemblies are aborted mid-flight when one of them fails, so
	// clean up after them no matter how the build ends.
	process.on('exit', cleanUpTemporaryFiles);

	// Compress music data and generate music-related assembler input.
	await generateMusicData();

	// Produce PCM and DPCM data.
	common.convertPcmFilesInDirectory('sound/PCM');
	common.convertDpcmFilesInDirectory('sound/DAC');

	// Build the ROM.
	await common.buildRomAndHandleFailure('s2', 's2built', [], {
		padding_value: 0,
		compressed_segments: [{
			starting_address: 0,
			compression: improved_sound_driver_compression ? 'saxman-optimised' : 'saxman-bugged',
			constant: 'Size_of_Snd_driver_guess',
			type: 'after',
		}],
	}, true);

	// Patch the ROM with the correct sound driver size.
	amendSoundDriverSize();

	// Correct the ROM's header with a proper checksum and end-of-ROM value.
	common.fixHeader('s2built.bin');
}

module.exports = build;

if (require.main === module)
	build().then(common.exit);
