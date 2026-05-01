---
description: Analyze code changes on the current branch vs main, find untested code paths, and write high-quality tests
---

Write tests for all untested code paths introduced on the current branch. Tests must exercise the REAL code — never reimplement logic inside tests.

## Step 1: Identify what changed

Run `git diff main...HEAD --name-only` to see all files changed on this branch.

Separate them into:
- **Frontend files** — `.ts`/`.tsx` files outside `backend/`
- **Backend files** — Python files in `backend/`

Ignore non-code files (docs, configs, markdown, etc.) unless they affect test setup.

## Step 2: Search for existing tests

Before writing anything, find tests that ALREADY exist for the changed code:

**Frontend:**
- Search `tests/vitest/` for test files that import from or test the changed modules
- Run `grep -r "CHANGED_MODULE_NAME" tests/vitest/` to find related tests

**Backend:**
- Search `backend/tests/` for test files covering the changed modules
- Run `grep -r "CHANGED_FUNCTION_OR_CLASS" backend/tests/` to find related tests

Read any existing test files to understand:
1. What's already covered — **do NOT duplicate existing tests**
2. The testing style and conventions used in this project
3. What test utilities/fixtures are available

## Step 3: Analyze code for testable paths

For each changed file, read the FULL file (not just the diff) and identify:

1. **New functions/methods** — These need tests
2. **Modified functions** — Check if existing tests cover the new behavior; if not, add tests
3. **New branches/conditions** — Edge cases, error paths, boundary conditions
4. **New integrations** — API calls, database queries, external service interactions

Prioritize what to test:
- **Pure logic** (transforms, calculations, parsing, validation) → HIGHEST priority, easiest to test
- **State management** (store actions, reducers) → HIGH priority
- **Utilities and helpers** → HIGH priority
- **API endpoints and services** → HIGH priority
- **Components with complex logic** → MEDIUM priority (test the logic, not the rendering)
- **Simple glue code / pass-through** → LOW priority, skip unless critical

## Step 4: Write tests

### Critical Rules

1. **Test the REAL code.** Import the actual function/class from the actual source file. NEVER copy or reimplement the function being tested inside the test file. The entire point of tests is to catch regressions when the source code changes — reimplementing defeats this purpose.

2. **Mocks are for dependencies, not for the thing being tested.** Mock external services, databases, network calls, and side effects. NEVER mock the function you're testing. If you find yourself mocking so much that the test doesn't exercise real code, reconsider your approach.

3. **Test behavior, not implementation.** Tests should verify WHAT the code does (inputs → outputs, side effects), not HOW it does it internally. This makes tests resilient to refactoring.

4. **Each test should catch a real regression.** Ask yourself: "If someone breaks this code in the future, will this test catch it?" If the answer is no, the test is worthless.

### Frontend Test Conventions

- Tests go in `tests/vitest/` mirroring the source structure (e.g. `core/scene/foo.ts` → `tests/vitest/core/scene/foo.test.ts`)
- Use `*.test.ts` extension
- Vitest with globals enabled (`describe`, `it`, `expect` available without imports)
- Import source using `@/` paths: `import { myFunction } from '@/lib/myModule'`
- Default environment is `node` — for tests that need DOM, add `// @vitest-environment jsdom` at the top of the file
- Prefer pure-logic tests in `node` environment when possible (faster, simpler)
- Only use `jsdom` when testing code that genuinely needs DOM APIs

Example structure:
```typescript
import { calculateLayout } from '@/core/scene/layout';

describe('calculateLayout', () => {
  it('should handle empty input', () => {
    expect(calculateLayout([])).toEqual({ width: 0, height: 0 });
  });

  it('should calculate correct bounds for nested nodes', () => {
    const nodes = [/* real test data */];
    const result = calculateLayout(nodes);
    expect(result.width).toBeCloseTo(100);
  });
});
```

### Backend Test Conventions

- Tests go in `backend/tests/` mirroring the source structure (e.g. `app/services/foo.py` → `tests/services/test_foo.py`)
- Use `test_*.py` file naming and `test_*` function naming
- pytest with `asyncio_mode="auto"` — async tests just work
- Use existing fixtures from `conftest.py` files (check `backend/tests/conftest.py` and subdirectory conftest files)
- Use `monkeypatch` for patching, `AsyncMock` for async dependencies
- Run individual test: `cd backend && uv run pytest tests/path/test_file.py::test_name -v`

Example structure:
```python
import pytest
from unittest.mock import AsyncMock, patch
from app.services.my_service import process_data

@pytest.mark.asyncio
async def test_process_data_handles_empty_input():
    result = await process_data([])
    assert result == []

@pytest.mark.asyncio
async def test_process_data_filters_invalid_entries():
    data = [{"valid": True}, {"valid": False}]
    result = await process_data(data)
    assert len(result) == 1
```

## Step 5: Verify tests pass

Run the tests you wrote:

**Frontend:**
```
npm run test:run -- tests/vitest/path/to/your/test.test.ts
```

**Backend:**
```
cd backend && uv run pytest tests/path/to/test_file.py -v
```

If tests fail, fix them. But be careful: if a test fails because the source code has a BUG, that's a GOOD test — note the bug, don't "fix" the test to pass around it.

Then run the full suite to make sure you haven't broken anything:
- Frontend: `npm run test:run`
- Backend: `cd backend && make test`

## Step 6: Format

Run `make total-format` to format all changed files.

## Output Summary

### Tests Written
| # | Test File | Tests Source File | What's Tested |
|---|-----------|-------------------|---------------|
| 1 | `tests/vitest/path/test.test.ts` | `core/path/module.ts` | Brief description |

### Skipped (already tested)
| # | Source File | Existing Test File | Coverage |
|---|------------|-------------------|----------|
| 1 | `path/module.ts` | `tests/vitest/path/test.test.ts` | Already covers X, Y |

### Skipped (not worth testing)
| # | Source File | Reason |
|---|------------|--------|
| 1 | `path/file.ts` | Simple pass-through / config change / etc. |

### Bugs Found
List any bugs discovered while writing tests (tests that correctly fail against buggy source code).

### Test Results
- All new tests pass: ✅/❌
- Full frontend suite: ✅/❌
- Full backend suite: ✅/❌ (if applicable)
