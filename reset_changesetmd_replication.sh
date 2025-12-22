#!/bin/bash
#
# reset_changesetmd_replication.sh
#
# Designed to be run from cron, as the user that owns the "changesets" database
# Status updates are written to the osm_changeset_state table in that database.
#
local_filesystem_user=localuseraccount
#
# First things first - is it already running?
#
sudo -u ${local_filesystem_user} psql -d changesets -t -c "update osm_changeset_state set update_in_progress = 0" > /dev/null 2>&1
#
