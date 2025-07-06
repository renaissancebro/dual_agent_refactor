-e ## Open
### General
- [ ] Restructure the project into a proper FastAPI application instead of a simple script.
- [ ] Use `python-dotenv` to load secrets and configurations like `API_KEY` from a `.env` file instead of hardcoding them.
- [ ] Eliminate global variables (`API_KEY`, `DEBUG_MODE`, `CACHE`).

### `main.py`
- [ ] Refactor the nested loops in `process_data` to improve readability and efficiency.
- [ ] Make `user_id` and `filename` in `main()` configurable instead of being hardcoded.
- [ ] Improve error handling to be more specific (e.g., catch `IOError` in `save_to_file` instead of generic `Exception`).
- [ ] Implement Pydantic models for data validation, especially for the expected structure of `user_data`.

### `test.py`
- [ ] Replace the invalid code (`print(hh)`) with actual unit tests.
- [ ] Implement tests for `process_data` and `calculate_total` using a testing framework like `pytest`.
- [ ] Mock the `requests.get` call to test `get_user_data` without making real network calls.
