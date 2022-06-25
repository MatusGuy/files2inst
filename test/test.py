from sys import argv as args
from os import path, system as cmd

COMMAND = args[1]

RBXMK_PATH = "rbxmk"

SCRIPT_DIR = path.dirname(path.realpath(__file__))
TARGET_SCRIPT = SCRIPT_DIR+"\\..\\src\\main.lua"
MODEL_FILE = SCRIPT_DIR+"\\test.rbxm"

RUN = f"{RBXMK_PATH} run {TARGET_SCRIPT} {COMMAND};{MODEL_FILE}"

print("files2inst main test")
print("running: "+RUN)
cmd(RUN)