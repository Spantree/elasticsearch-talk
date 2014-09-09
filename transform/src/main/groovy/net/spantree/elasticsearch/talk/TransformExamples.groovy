package net.spantree.elasticsearch.talk

import groovy.io.FileType
import org.apache.commons.lang.WordUtils
import groovy.json.JsonOutput
import uk.co.cacoethes.handlebars.HandlebarsTemplateEngine

// import static net.spantree.elasticsearch.talk.ExampleParts.*
class TransformExamples {
    enum ExampleParts {
        TITLE, DESCRIPTION, REQUEST, PAYLOAD
    }

    static String indexTemplate = """
    <html>
        <head>
            <title>Spantree Elasticsearch Talk</title>
            <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/bootstrap/3.1.0/css/bootstrap-theme.css"/>
            <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/flat-ui/2.0/css/flat-ui.css"/>
        </head>
        <body>
            <h1>Spantree Elasticsearch Talk</h1>

            <h2>Resources</h2>
            <ul>
                <li>
                    <a href="/slides/" target="es_slides">Slides</a>
                </li>
                <li>
                    <a href="{{esRoot}}" target="es_rest">Elasticsearch REST Interface</a>
                </li>
                <li>
                    <a href="{{esRoot}}/_plugin/marvel/" target="es_marvel">Marvel Plugin</a>
                </li>
                <li>
                    <a href="{{esRoot}}/_plugin/head/" target="es_head">Head Plugin</a>
                </li>
                <li>
                    <a href="{{esRoot}}/_plugin/marvel/sense/" target="es_sense">Sense API Explorer</a>
                </li>
            </ul>

            <h2>Example REST Calls</h2>
            <ul>
                {{#each chapters}}
                    <li>
                        <a href="{{esRoot}}/_plugin/marvel/sense/#{{this}}" target="es_sense_{{this}}">{{@key}}</a>
                    </li>
                {{/each}}
            </ul>
        </body>
    </html>
    """

    static void writeExampleOut(Writer out, Map parts, Integer chapter, Integer exampleNumber) {
        println parts
        def title = parts.title.replaceAll(/^##/, '').trim()
        def description = WordUtils.wrap(parts.description?.replaceAll(/\s+/, ' '), 40).trim()
        def request = parts.request?.replaceAll(/`/, '')?.trim()
        def payload = parts.payload?.replaceAll(/```\w*/, '')?.trim()

        if(payload) {
            payload = request.endsWith('_bulk') ? payload : JsonOutput.prettyPrint(payload).replaceAll(/\{\s+\}/, '{}')
        }

        out.writeLine "# ${chapter}.${exampleNumber}: ${title}"

        if(description) {
            out.writeLine '#'
            description.eachLine { line ->
                out.writeLine "# ${line.trim()}"
            }
        }

        if(request) {
            out.writeLine ''
            out.writeLine request
        }

        if(payload) {
            out.writeLine payload
        }
        out.writeLine ''
    }

    static void writeIndex(Map chapters, File target) {
        println chapters
        def handlebars = new HandlebarsTemplateEngine()
        def template = handlebars.createTemplate(new StringReader(indexTemplate))
        def model = [
            esRoot: 'http://esdemo.local:9200',
            chapters: chapters
        ]
        def file = new File('index.html', target)
        file.withWriter { out ->
            template.make(model).writeTo(out)
        }
    }


    static void main(String[] args) {
        // Find Markdown files in the examples folder
        def folder = new File('../examples')
        def target = new File('www')
        target.mkdirs()
        def chapters = [:]

        folder.eachFileMatch(FileType.FILES, ~/.*\.md$/) { f ->
            // parse the chapter number from the first part of the filename
            def chapter = Integer.parseInt((f.name =~ /^\d+/)[0])
            // start the example index from 1
            def exampleNumber = 1
            // our target filename will have a `.sense` extension
            def outFilename = f.name.replaceFirst(~/\.[^\.]+$/, '.sense')

            // use a parts map to keep track of the various parts of the example
            def parts = null
            // flag the current part based on the most recently processed line
            def currentPart = null

            // start writing the file
            new File(outFilename, target).withWriter { out ->
                f.eachLine { line ->
                    // the top-level header indicates a chapter title, output with decoration
                    if(line.startsWith('# ')) {
                        def chapterTitle = "${chapter}.0: ${line.replaceAll('^#', '').trim()}"
                        chapters[chapterTitle] = outFilename.replaceAll(/\.sense$/, '')

                        out.writeLine '#'*(chapterTitle.size()+4)
                        out.writeLine "# ${chapterTitle.toUpperCase()} #"
                        out.writeLine '#'*(chapterTitle.size()+4)
                        out.writeLine '#'
                    }

                    // the second-level header indicates an example title
                    if(line.startsWith('## ')) {
                        // if we have a part map from the previous example, write it out to our sense file
                        if(parts) {
                            writeExampleOut(out, parts, chapter, exampleNumber++)
                        }

                        // reinitialize the parts map with values from this example
                        parts = [
                            title: line,
                            description: '',
                            request: '',
                            payload: ''
                        ]
                        // assume the next line is part of the description
                        currentPart = ExampleParts.DESCRIPTION
                    } else if(currentPart == ExampleParts.DESCRIPTION) {
                        if(!line.startsWith('`')) {
                            // if we haven't seen a backtick yet, assume we're still processing the description
                            parts.description = "${parts.description} ${line}"
                        } else {
                            // otherwise, if we see a backtick, assume we're looking at the HTTP request line
                            parts.request = line
                            // expect the next lines to be part of the payload
                            currentPart = ExampleParts.PAYLOAD
                        }
                        // if we're processing the payload, output the line in the payload part
                    } else if(currentPart == ExampleParts.PAYLOAD) {
                        parts.payload = "${parts.payload}${line}\n"
                    }
                }
                if(parts) {
                    writeExampleOut(out, parts, chapter, exampleNumber++)
                }
            }
        }
        writeIndex(chapters, target)
    }
}
