///|
pub async fn copy(src~ : SourcePath, dst~ : SourcePath) -> Unit {
  let src_str = "\{src}"
  let dst_str = "\{dst}"
  guard @fs.exists(src_str) else { fail("Source path does not exist: \{src}") }
  if @fs.kind(src_str) is Directory {
    @fs.mkdir(dst_str, permission=0o755, recursive=true)
    for entry in @fs.readdir(src_str, include_hidden=true, sort=true) {
      copy(src=src.join(entry), dst=dst.join(entry))
    }
  } else {
    let parent = @path.Path::dirname(dst_str).to_string()
    if parent != "" && parent != "." && !@fs.exists(parent) {
      @fs.mkdir(parent, permission=0o755, recursive=true)
    }
    let reader = @fs.open(src_str, mode=ReadOnly)
    defer reader.close()
    let writer = @fs.open(
      dst_str,
      mode=WriteOnly,
      create_mode=CreateOrTruncate,
      permission=0o644,
    )
    defer writer.close()
    writer.write_reader(reader)
  }
}

///|
#cfg(not(platform="windows"))
pub async fn chmod_executable(path : SourcePath) -> Unit {
  @fs.chmod(source_path_to_string(path), 0o755)
}

///|
#cfg(platform="windows")
pub async fn chmod_executable(_path : SourcePath) -> Unit {
  ignore(_path)
}
