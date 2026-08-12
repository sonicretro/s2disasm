#!/usr/bin/env node

const build = require('./build.js');
const common = require('./build_tools/node/common.js');

// The hashes of the ROMs that the original releases were built from.
const known_builds = {
	'8e2c29a1e65111fe2078359e685e7943': 'REV00',
	'9feeb724052c39982d432a7851c98d3e': 'REV01',
	'11d8d0d1d119d9c731bbf1f3032ff032': '(the theoretical) REV02',
};

build().then(function () {
	// Verify the ROM's hash against the known builds.
	const revision = known_builds[common.hashFile('s2built.bin')];

	console.log('-------------------------------------------------------------');

	if (revision !== undefined)
		console.log('ROM is bit-perfect with ' + revision + '.');
	else
		console.log('ROM is NOT bit-perfect with REV00, REV01, or REV02!');

	common.exit();
});
