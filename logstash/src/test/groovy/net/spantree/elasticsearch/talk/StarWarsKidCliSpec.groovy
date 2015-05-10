package net.spantree.elasticsearch.talk

import spock.lang.Specification

import java.time.Month
import java.time.ZoneOffset

import static net.spantree.elasticsearch.talk.StarWarsKidCli.*

class StarWarsKidCliSpec extends Specification {
    def "should parse date"() {
        given:
        def dateStr = "10/Apr/2003:00:04:48 -0700"

        when:
        def date = parseDateString(dateStr)

        then:
        date.dayOfMonth == 10
        date.month == Month.APRIL
        date.year == 2003
        date.hour == 0
        date.minute == 4
        date.second == 48
        date.offset == ZoneOffset.ofHours(-7)
    }

    def "should extract date from log line"() {
        given:
        def line = '67.68.233.96 - - [10/Apr/2003:03:04:46 -0700] "GET /archive/2003/03/26/hiding_s.shtml HTTP/1.1" 200 17019 "http://www.planetps2.com/mmcafe/index.html" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)"'

        when:
        def date = getDateFromLine(line)

        then:
        date
        date.dayOfMonth == 10
        date.month == Month.APRIL
        date.year == 2003
        date.hour == 3
        date.minute == 4
        date.second == 46
        date.offset == ZoneOffset.ofHours(-7)
    }

    def "should get last line from file"() {
        given:
        def file = new File(getClass().getResource("/test.log").file)

        when:
        def lastLine = getLastLineFromFile(file)

        then:
        lastLine == '69.10.137.199 - - [10/Apr/2003:03:05:01 -0700] "GET /watch-info HTTP/1.0" 200 75 "-" "-"'
    }
}
