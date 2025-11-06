# resource "google_cloudfunctions2_function" "my_function" {
#   name        = "sendErrorReport"
#   description = "Sending reports about errors enriched with AI analysis"
#   runtime     = "nodejs22"
  #   entry_point = "handler"
#   event_trigger {
#
#   }
#   source_archive_bucket = google_storage_bucket.functions_bucket.name
#   source_archive_object = google_storage_bucket_object.function_zip.name
#   trigger_http = true
#   available_memory_mb = 256
# }
#TODO
