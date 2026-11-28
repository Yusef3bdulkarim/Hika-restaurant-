import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';

import {
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from '@firebase/rules-unit-testing';

// Set by `firebase emulators:exec` to the active project (.firebaserc default).
const projectId = process.env.GCLOUD_PROJECT;

export async function createTestEnv(): Promise<RulesTestEnvironment> {
  if (projectId === undefined) {
    throw new Error('GCLOUD_PROJECT missing — run via `npm run test:rules`.');
  }
  const root = resolve(import.meta.dirname, '../../..');
  return initializeTestEnvironment({
    projectId,
    firestore: { rules: readFileSync(resolve(root, 'firestore.rules'), 'utf8') },
    storage: { rules: readFileSync(resolve(root, 'storage.rules'), 'utf8') },
  });
}
