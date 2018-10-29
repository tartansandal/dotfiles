import os


def Settings(**kwargs):
    # try to dynamically detect virtualenvs

    for path in [
        './venv-host',
        './venv-guest',
        './venv',
        './.env',
    ]:
        path += '/bin/python'
        if os.path.exists(path):
            return {'interpreter_path': path}

    return
