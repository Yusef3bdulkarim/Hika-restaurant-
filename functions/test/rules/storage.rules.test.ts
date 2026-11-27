import {
  assertFails,
  type RulesTestEnvironment,
} from '@firebase/rules-unit-testing';
import { afterAll, beforeAll, describe, test } from 'vitest';

import { createTestEnv } from './test-env.js';

let testEnv: RulesTestEnvironment;

beforeAll(async () => {
  testEnv = await createTestEnv();
});

afterAll(async () => {
  await testEnv.cleanup();
});

describe('storage.rules (deny-all)', () => {
  test('should deny upload when user is authenticated', async () => {
    const storage = testEnv.authenticatedContext('alice').storage();

    await assertFails(
      // UploadTask is thenable, not a Promise.
      Promise.resolve(
        storage.ref('receipts/alice/order1/receipt.jpg').putString('x'),
      ),
    );
  });

  test('should deny read when user is unauthenticated', async () => {
    const storage = testEnv.unauthenticatedContext().storage();

    await assertFails(
      storage.ref('receipts/alice/order1/receipt.jpg').getDownloadURL(),
    );
  });
});
