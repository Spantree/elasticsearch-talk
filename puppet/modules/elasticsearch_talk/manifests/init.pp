class elasticsearch_talk {
	exec {'Create sense scripts':
    command => "/opt/groovy-2.2.1/bin/groovy TransformExamples.groovy",
    cwd     => "/usr/src/elasticsearch-talk/scripts"
  }
}