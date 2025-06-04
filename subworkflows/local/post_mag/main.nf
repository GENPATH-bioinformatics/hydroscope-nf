// TODO nf-core: If in doubt look at other nf-core/subworkflows to see how we are doing things! :)
//               https://github.com/nf-core/modules/tree/master/subworkflows
//               You can also ask for help via your pull request or on the #subworkflows channel on the nf-core Slack workspace:
//               https://nf-co.re/join
// TODO nf-core: A subworkflow SHOULD import at least two modules

include { KRAKENTOOLS_KREPORT2KRONA } from '../../../modules/nf-core/krakentools/kreport2krona/main'

workflow POST_MAG {

    main:
    ch_versions = Channel.empty()

    if (params.krona ) {
        // Concatenate Mapped_R1 with Unmapped_R1 and Mapped_R2 with Unmapped_R2
        KRAKENTOOLS_KREPORT2KRONA(params.kreport)

        // Gather versions of all tools used
        ch_versions = ch_versions.mix(KRAKENTOOLS_KREPORT2KRONA.out.versions)
    }



    emit:
    // TODO nf-core: edit emitted channels
    versions = ch_versions                     // channel: [ versions.yml ]
}

