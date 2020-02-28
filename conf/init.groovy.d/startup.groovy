#!/usr/bin/env groovy

import java.util.logging.Logger
import jenkins.model.Jenkins
import hudson.model.*
import hudson.markup.RawHtmlMarkupFormatter
import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement

/**
 * Startup script
 */
println "--- Started ---"

Logger.global.info("[Running] startup script")

println "--- Conf ---"
configureJenkins()

println "--- Jobs ---"
seedJenkinsJobs()

println "--- Views ---"
seedJenkinsViews()

Logger.global.info("[Done] startup script")

println "--- Finished ---"

/**
 * Configure jenkins default settings
 */
private void configureJenkins() {
    // disable jenkins security
    Jenkins.getInstance().disableSecurity()

    // disable security warning
    List<AdministrativeMonitor> p = jenkins.model.Jenkins.instance.getActiveAdministrativeMonitors()
    p.each { x ->
        if (x.getClass().name.contains("SecurityIsOffMonitor")) {
            x.disable(true)
        }
    }

    // set markupformatter
    Jenkins.instance.setMarkupFormatter(new RawHtmlMarkupFormatter(false))

    // set jenkins executors number
    Jenkins.instance.setNumExecutors(6)
}


/**
 * Creates jenkins default jobs
 */
private void seedJenkinsJobs() {
    File seeds = new File('/usr/share/jenkins/ref/jobs/')
    JenkinsJobManagement jobManagement = new JenkinsJobManagement(System.out, [:], new File('.'))

    new DslScriptLoader(jobManagement).with {
        seeds.eachFileRecurse (groovy.io.FileType.FILES) { file ->
            if (file.name.endsWith('.groovy')) {
                runScript(file.text)
            }
        }
    }
}


/**
 * Creates jenkins default views
 */
private void seedJenkinsViews() {
    File seeds = new File('/usr/share/jenkins/ref/views/')
    JenkinsJobManagement jobManagement = new JenkinsJobManagement(System.out, [:], new File('.'))

    new DslScriptLoader(jobManagement).with {
        seeds.eachFileRecurse (groovy.io.FileType.FILES) { file ->
            if (file.name.endsWith('.groovy')) {
                runScript(file.text)
            }
        }
    }
}

