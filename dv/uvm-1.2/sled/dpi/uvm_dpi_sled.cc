#include "svdpi.h"
#include "sled/SimpleClient.hh"

#include <map>
#include <string>


extern "C" {

    static int initialize;
    static SLED::Simple::LogStream*     log ;
    static SLED::LogSeverity_t  arr_sled[] = {SLED::Note, SLED::Warning, SLED::Error, SLED::Fatal} ;

    void
        sled_log(char*  stream, int severity, char* message, uint64_t timestamp, bool different_stream) {
            if(initialize == 0 && !different_stream ) {
                static auto *run = SLED::Simple::Run::getRun();
                if (run == NULL) run = SLED::Simple::Run::open("UVM_SLED");
                if (run == NULL) return;
                static auto src = run->createSource("VCS", "UVM");
                log = src->createLogStream("UVM");
                log->log(arr_sled[severity], message, timestamp);
                initialize = 1;
            }
            else if(different_stream){
                auto run = SLED::Simple::Run::getRun();
                if (run == NULL) run = SLED::Simple::Run::open("UVM_SLED");
                if (run == NULL) return;
                auto src  = run->createSource("VCS", "UVM"); 
                log = src->createLogStream(stream);
                log->log(arr_sled[severity], message, timestamp);
            }
            else
                log->log(arr_sled[severity], message, timestamp);

        }

}
