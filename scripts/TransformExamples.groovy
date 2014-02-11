import groovy.io.FileType

def folder = new File('../examples')
boolean inJsonBlock = false
int i = 0
folder.eachFileMatch(FileType.FILES, ~/.*\.md$/) { f ->
    def c = Integer.parseInt((f.name =~ /^\d+/)[0])
    def e = 1
    f.eachLine { line ->
        if (line.trim() == '```') {
            inJsonBlock = false
        } else if (inJsonBlock) {
            println line
        } else if (line.startsWith('# ')) {
            if (i > 0) {
                println ''
            }
            line = line.replaceAll(/^#\s*/, '').toUpperCase()
            line = "# ${c}.0: ${line}"
            println '#' * line.size()
            println line
            println '#' * line.size()
        } else if (line.startsWith('## ')) {
            line = line.replaceAll(/^##\s*/, '')
            println "\n# ${c}.${e++}: ${line}\n"
        } else if (line =~ /^`[^`]/) {
            println line.replaceAll('`', '')
        } else if (line =~ /^```json/) {
            inJsonBlock = true
        }
        i++
    }
}