package net.spantree.elasticsearch.talk

import groovy.transform.CompileStatic
import groovy.util.logging.Slf4j

import java.time.LocalDateTime
import java.time.OffsetDateTime
import java.time.ZoneOffset
import java.time.format.DateTimeFormatter
import java.util.regex.Pattern

@Slf4j
class StarWarsKidCli {
    static DateTimeFormatter dateTimeFormat = DateTimeFormatter.ofPattern("dd/MMM/yyyy:HH:mm:ss Z")
    static Pattern dateTimePattern = Pattern.compile("\\[([^\\]]*)\\]")
    static Long fileLines = 0

    @CompileStatic
    static OffsetDateTime parseDateString(String dateStr) {
        OffsetDateTime.parse(dateStr, dateTimeFormat)
    }

    @CompileStatic
    static String getDateStringFromLine(String line) {
        def m = dateTimePattern.matcher(line)
        m.find() ? m.group(1) : null
    }

    @CompileStatic
    static OffsetDateTime getDateFromLine(String line) {
       String dateStr = getDateStringFromLine(line)
       dateStr ? parseDateString(dateStr) : null
    }

    @CompileStatic
    static String getLastLineFromFile(File file) {
        String lastLine = null
        String line = null
        file.withReader { reader ->
            while(line = reader.readLine()) {
                lastLine = line
                fileLines++
            }
        }
        lastLine
    }

    @CompileStatic
    static void streamLogFile(File inFile, File outFile, int secondsToAdd) {
        def reader = new BufferedReader(new FileReader(inFile))
        def writer = new BufferedWriter(new FileWriter(outFile))
        try {
            int i = 0
            String lastDateStr = null
            OffsetDateTime date = null
            Long adjustedEpochSeconds = null
            OffsetDateTime adjustedDate = null
            String adjustedDateStr = null
            String line = null
            while (line = reader.readLine()) {
                if (secondsToAdd != 0) {
                    def dateStr = getDateStringFromLine(line)
                    if (dateStr != lastDateStr) {
                        date = parseDateString(dateStr)
                        adjustedEpochSeconds = date.toEpochSecond() + secondsToAdd
                        adjustedDate = OffsetDateTime.of(LocalDateTime.ofEpochSecond(adjustedEpochSeconds, 0, ZoneOffset.UTC), date.offset)
                        adjustedDateStr = dateTimeFormat.format(adjustedDate)
                    }
                    lastDateStr = dateStr

                    if (adjustedEpochSeconds < System.currentTimeMillis() / 1000) {
                        def adjustedLine = line.replaceFirst(dateTimePattern, "[${adjustedDateStr}]")
                        if (i++ % 1000 == 0) {
                            log.info "Writing log line ${i}/${fileLines} with ${adjustedDate}"
                        }
                        writer.writeLine(adjustedLine)
                        writer.flush()
                    } else {
                        Thread.sleep(500)
                    }
                } else {
                    if (i++ % 1000 == 0) {
                        log.info "Writing log line ${i}/${fileLines}"
                    }
                    writer.writeLine(line)
                    writer.flush()
                }
            }
        } finally {
            reader.close()
            writer.close()
        }
    }

    public static void main(String[] args) {
        def cli = new CliBuilder()
        cli.with {
            i longOpt: 'in-file', args: 1, required: true, 'The input file'
            o longOpt: 'out-file', args: 1, required: true, 'The output file'
            h longOpt: 'hours-to-stream', args: 1, 'Number of hours to stream from the end of the log'
        }

        def opts = cli.parse(args)

        def inFile = new File(opts.i)
        def outFile = new File(opts.o)
        outFile.delete()
        Integer streamHours = opts.h ? Integer.parseInt(opts.h) : null

        log.info "Scanning to last line of file"
        def lastLine = getLastLineFromFile(inFile)
        def lastDate = getDateFromLine(lastLine)

        log.info "Found last date ${lastDate}"

        int secondsToAdd = (streamHours == null ? 0 : new Date().getTime()/1000 - lastDate.toEpochSecond() + streamHours * 60 * 60)

        log.info "Writing log with ${secondsToAdd}s adjustment"

        streamLogFile(inFile, outFile, secondsToAdd)
    }
}
