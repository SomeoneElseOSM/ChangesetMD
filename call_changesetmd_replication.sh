#!/bin/bash
#
# call_changesetmd_replication.sh
#
# Designed to be run from cron, as the user that owns the "changesets" database
# Status updates are written to the osm_changeset_state table in that database.
#
local_filesystem_user=localuseraccount
#
# First things first - is it already running?
#
wclines=`psql -d changesets -t -c "select update_in_progress from osm_changeset_state" | wc -l`;
if [ $wclines -eq 2 ]
then
    cd /home/${local_filesystem_user}/src/ChangesetMD
    source .venv/bin/activate
    echo "ChangesetMD replication starting - current timestamp:"
    psql -d changesets -t -c "select last_timestamp from osm_changeset_state"
    python changesetmd.py -d changesets -r -g > /dev/null
    echo "ChangesetMD replication complete - last timestamp:"
    psql -d changesets -t -c "select last_timestamp from osm_changeset_state"
else
    echo "ChangesetMD replication already running - last sequence:";
    psql -d changesets -t -c "select last_sequence from osm_changeset_state"
fi
#
