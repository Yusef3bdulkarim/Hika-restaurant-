// Windows: when the shell's cwd has a lower-case drive letter (f:\), Vitest
// loads itself twice and fails with "failed to find the runner".
// Re-run Vitest from the real path (F:\). Args are passed through.
import { spawnSync } from 'node:child_process';
import { realpathSync } from 'node:fs';
import { join } from 'node:path';
import process from 'node:process';

const cwd = realpathSync.native(process.cwd());
const vitest = join(cwd, 'node_modules', 'vitest', 'vitest.mjs');
const { status } = spawnSync(
  process.execPath,
  [vitest, ...process.argv.slice(2)],
  { cwd, stdio: 'inherit' },
);
process.exit(status ?? 1);
