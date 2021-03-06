### Internal function to obtain a response from a PUT call
brapi_PUT <- function(url, body, usedArgs) {
  brapi_message(msg = paste0("URL call was: ", url, "\n"))
  brapi_message(msg = paste0("Waiting for response from server: ...\n"))

  if ("format" %in% names(usedArgs)) {
    if (is.na(usedArgs[["format"]])) {
      usedArgs[["format"]] <- "NA"
    }
    switch(usedArgs[["format"]],
           "NA" = {
             usedArgs[["Accept"]] <- "application/json"},
           "csv" = {
             usedArgs[["Accept"]] <- "text/csv"},
           "tsv" = {
             usedArgs[["Accept"]] <- "text/tsv"},
           "flapjack" = {
             usedArgs[["Accept"]] <- "application/flapjack"})
  }

  if ("Accept" %in% names(usedArgs)) {
    if ("Content-Type" %in% names(usedArgs)) {
      resp <- httr::PUT(url = url,
                        body =  jsonlite::toJSON(body),
                        httr::timeout(25),
                        httr::add_headers("Accept" = usedArgs[["Accept"]],
                                          "Authorization" = paste("Bearer", usedArgs[["con"]][["token"]])),
                        httr::content_type(usedArgs[["Content-Type"]]))
    } else {
      resp <- httr::PUT(url = url,
                        body = body,
                        encode = "json",
                        httr::timeout(25),
                        httr::add_headers("Accept" = usedArgs[["Accept"]],
                                          "Authorization" = paste("Bearer", usedArgs[["con"]][["token"]])))
    }
  } else {
    resp <- httr::PUT(url = url,
                      body = body,
                      encode = "json",
                      httr::timeout(25),
                      httr::add_headers("Authorization" = paste("Bearer", usedArgs[["con"]][["token"]])))
  }

  txt <- ifelse(resp[["status_code"]] == 200, " ok!", " problem!")
  brapi_message(msg = paste0("Server status: ", txt, "\n"))
  # url <- httr::content(resp)
  # if (format == "json") show_server_status_messages(resp)
  return(resp)
}
