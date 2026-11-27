import {
  assertFails,
  type RulesTestEnvironment,
} from '@firebase/rules-unit-testing';
import { afterAll, beforeAll, beforeEach, describe, test } from 'vitest';

import { createTestEnv } from './test-env.js';

let testEnv: RulesTestEnvironment;

beforeAll(async () => {
  testEnv = await createTestEnv();
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

afterAll(async () => {
  await testEnv.cleanup();
});

describe('firestore.rules (deny-all)', () => {
  test('should deny read when user is unauthenticated', async () => {
    const db = testEnv.unauthenticatedContext().firestore();

    await assertFails(db.doc('menu_items/any').get());
  });

  test('should deny read when user is authenticated', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();

    await assertFails(db.doc('users/alice').get());
  });

  test('should deny write when user is authenticated', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();

    await assertFails(db.doc('users/alice').set({ name: 'Alice' }));
  });

  test('should deny write when user is unauthenticated', async () => {
    const db = testEnv.unauthenticatedContext().firestore();

    await assertFails(db.doc('users/alice').set({ name: 'Alice' }));
  });

  test('should deny list when user is authenticated', async () => {
    const db = testEnv.authenticatedContext('alice').firestore();

    await assertFails(db.collection('menu_items').get());
  });
});
