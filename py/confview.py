import sys
import ConfigParser

if len(sys.argv) != 3:
  print("Usage: %s <file> <section>" % (sys.argv[0]))
  exit()

file, section = sys.argv[1:3]

config = ConfigParser.ConfigParser()
if not config.read(file):
  print("Config file '%s' not found" % file)
  exit()
config.sections()
try:
  for option in config.options(section):
    print("%s=%s" % (option, config.get(section,option)))
except:
  print("No section [%s] in '%s'" % (section,file))
