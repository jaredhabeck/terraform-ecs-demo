import sys

envFile = sys.argv[1]

try:
    with open(envFile, "r") as file:
        for line in file:
            if line and "=" in line:
                key, value = line.split("=", 1)
                terraformString = f"""\
{{
  Name = "{key}",
  ValueFrom = {value}
}},
                """
                print(terraformString)
except FileNotFoundError:
    print("File not found")
