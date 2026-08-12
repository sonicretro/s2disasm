// Runs the WebAssembly build of the Macro Assembler AS.
//
// The assembler is built with Emscripten's raw Node filesystem, so it reads and
// writes the repository's files directly.
//
// Each assembly is done in a child process, since the assembler is not designed
// to be ran more than once in the same process:
//   node build_tools/node/asl.js <root directory> -- <assembler arguments>

const path = require('path');
const {spawn} = require('child_process');

const wasm_directory = path.join(__dirname, 'wasm');
const message_directory = path.join(wasm_directory, 'msg');

// Runs the assembler in a child process, returning its exit code.
function assemble(root_directory, assembler_arguments) {
	return new Promise((resolve, reject) => {
		const child = spawn(process.execPath, [__filename, root_directory, '--', ...assembler_arguments], {stdio: 'inherit'});

		child.on('error', reject);
		child.on('close', resolve);
	});
}

async function assembleHere(root_directory, assembler_arguments) {
	const createASL = require('./wasm/asl.js');

	process.chdir(root_directory);

	const asl = await createASL({
		locateFile: (url) => path.join(wasm_directory, url),
		print: (text) => process.stdout.write(text + '\n'),
		printErr: (text) => process.stderr.write(text + '\n'),
		preRun: [function (asl) {
			// Tell the assembler where its message catalogues are.
			//
			// This has to be a path that's relative to the working directory,
			// using forward slashes: the assembler is a POSIX program, so it
			// would mangle a Windows path like 'C:\path\to\msg'.
			asl.ENV.AS_MSGPATH = path.relative(process.cwd(), message_directory).split(path.sep).join('/');
		}],
	});

	try {
		asl.callMain(assembler_arguments);
	} catch (e) {
		// Emscripten throws 'ExitStatus' when the program calls 'exit'.
		if (e.name !== 'ExitStatus')
			throw e;

		return e.status;
	}

	return 0;
}

module.exports = assemble;

if (require.main === module) {
	const root_directory = process.argv[2];
	const assembler_arguments = process.argv.slice(process.argv.indexOf('--') + 1);

	assembleHere(root_directory, assembler_arguments).then((exit_code) => {
		process.exitCode = exit_code;
	});
}
