import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'node',
    // Rules tests share one emulator; run files one after another.
    fileParallelism: false,
    testTimeout: 15_000,
  },
});
