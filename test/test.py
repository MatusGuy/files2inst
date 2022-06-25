from sys import argv as args
from os import path, system as cmd

COMMAND = args[1]
command_args = args[2:]
str_args = ""
for i, arg in enumerate(command_args):
    str_args += arg+(";" if not i == len(command_args)-1 else "")

RBXMK_PATH = "rbxmk"

SCRIPT_DIR = path.dirname(path.realpath(__file__))
TARGET_SCRIPT = SCRIPT_DIR+"\\..\\src\\main.lua"

RUN = f"{RBXMK_PATH} run {TARGET_SCRIPT} {COMMAND};{str_args}"

print(f"files2inst {COMMAND} test")
print("running: "+RUN)
cmd(RUN)