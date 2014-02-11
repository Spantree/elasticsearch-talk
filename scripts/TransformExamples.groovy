import groovy.io.FileType

def folder = new File('../examples')
boolean inJsonBlock = false
int i = 0
folder.eachFileMatch(FileType.FILES, ~/.*\.md$/) { f ->
    def c = Integer.parseInt((f.name =~ /^\d+/)[0])
    def e = 1
    def filename = f.name.replaceFirst(~/\.[^\.]+$/, '.sense')
    new File(filename).withWriter{out-> 
        f.eachLine { line ->
            if (line.trim() == '```') {
            inJsonBlock = false
            } else if (inJsonBlock) {
                out.writeLine line
            } else if (line.startsWith('# ')) {
                if (i > 0) {
                    out.writeLine ''
                }
                line = line.replaceAll(/^#\s*/, '').toUpperCase()
                line = "# ${c}.0: ${line}"
                out.writeLine '#' * line.size()
                out.writeLine line
                out.writeLine '#' * line.size()
            } else if (line.startsWith('## ')) {
                line = line.replaceAll(/^##\s*/, '')
                out.writeLine "\n# ${c}.${e++}: ${line}\n"
            } else if (line =~ /^`[^`]/) {
                out.writeLine line.replaceAll('`', '')
            } else if (line =~ /^```json/) {
                inJsonBlock = true
            }
            i++
        }
    }
}