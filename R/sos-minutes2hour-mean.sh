SYSTEMCODE="SCAPE604"
SYSTEMPATH="/opt"

LOGFILE=$SYSTEMPATH/$SYSTEMCODE/log/R_sos-minutes2hour-mean.log
echo "Start procedure on: " `date` >>$LOGFILE

cd $SYSTEMPATH/$SYSTEMCODE/apri-sensor-procedures

###node index knmi_10min_actual_import.js >>$LOGFILE

Rscript R/sos-minutes2hour-mean.R >>$LOGFILE

echo "End   procedure on: " `date` >>$LOGFILE
exit 0
