///|
#cfg(target="js")
async fn read_blob_body(blob : Blob) -> Bytes {
  blob.bytes().wait()
}

///|
#cfg(not(target="js"))
async fn read_blob_body(blob : Blob) -> Bytes {
  blob.bytes()
}
