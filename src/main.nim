import
  os,
  strformat,
  tables,
  libs/chinort_installer,
  libs/chinort_chooser


proc isParamOption(param: string): bool =
  return param[0] == '-'

type Chinotc = ref object
  commandLineParams: seq[string]
  messages: Table[string, string]
  chosenVersion: string


proc init(chinotc: Chinotc) =
  chinotc.commandLineParams = os.commandLineParams()
  chinotc.messages = {
    "help": "Usage:\n\tchinotc [args] [options]",
    "version": "Chinotc v0.0.1",
  }.toTable


proc installChinortCompiler(chinotc: Chinotc) =
  let chinortInstaller = ChinortInstaller()
  chinortInstaller.install()

proc chooseChinortCompiler(chinotc: Chinotc) =
  let chinortChooser = ChinortChooser()
  chinortChooser.choose(chinotc.chosenversion)

proc parseCommandLineParams(chinotc: Chinotc) =
  if chinotc.commandLineParams.len() < 1:
    echo chinotc.messages["help"]
    return
  if chinotc.commandLineParams[0].isParamOption():
    case chinotc.commandLineParams[0]:
      of "-h", "--help":
        echo chinotc.messages["help"]
      of "-v", "--version":
        echo chinotc.messages["version"]
      else:
        echo fmt"Unknown option '{chinotc.commandLineParams[0]}'."
        echo chinotc.messages["help"]
    return
  block:
    case chinotc.commandLineParams[0]:
      of "compiler":
        case chinotc.commandLineParams[1]:
          of "install":
            chinotc.installChinortCompiler()
          of "choose":
            if chinotc.commandLineParams.len() < 3:
              echo "Usage:\n\t$ chinotc compiler choose <version>"
              return
            chinotc.chosenVersion = chinotc.commandLineParams[2]
            chinotc.chooseChinortCompiler()
            echo fmt"Now Chinort compiler {chinotc.chosenVersion} will be used."
      else:
        echo fmt"Unknown argument '{chinotc.commandLineParams[0]}'."
        echo chinotc.messages["help"]

proc main(chinotc: Chinotc) =
  chinotc.init()
  chinotc.parseCommandLineParams()


if isMainModule:
  let chinotc = Chinotc()
  chinotc.main()
