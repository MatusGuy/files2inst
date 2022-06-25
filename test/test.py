from os import path, system as cmd

RBXMK_PATH = "rbxmk"

SCRIPT_DIR = path.dirname(path.realpath(__file__))
TARGET_SCRIPT = SCRIPT_DIR+"\\..\\src\\main.lua"
MODEL_FILE = SCRIPT_DIR+"\\test.rbxm"

COMMAND = f"{RBXMK_PATH} run {TARGET_SCRIPT} tree;{MODEL_FILE}"

print("files2inst main test")
print("running: "+COMMAND)
cmd(COMMAND)