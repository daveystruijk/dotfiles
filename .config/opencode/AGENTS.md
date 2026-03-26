
When checking untyped or unknown input, always resort to using validation libraries (e.g. zod) with predefined schemas instead of scattering code with manual checks (e.g. `isArray`).

Try to reuse (parts of) types from imported packages if they already exist.

Keep code as left-aligned as possible: Use guard clauses that return early instead of nested conditionals.

Don't create functions that contain single-line statements. Inline them instead with a clear variable name.
