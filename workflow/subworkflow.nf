
SAMPLESHEET_CHECK {

}


PRE_MAG {
    CONCATENATE(Channel.fromPath())
    BUILD_DB(Channel.fromPath())

}

POST_MAG {
    KRONA(Channel.fromPath())
    PAVIAN(Channel.fromPath())

}

