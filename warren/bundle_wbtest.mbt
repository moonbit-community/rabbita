///|
async test "bundle rejects a server entry without an asset stub" {
  let dir = @fs.tmpdir(prefix="warren-bundle-validation")
  defer @fs.rmdir(dir, recursive=true)
  let root = SourcePath::new(dir)
  let layout : ProjectLayout = {
    root,
    browser_entry: root,
    server_entry: Some(root),
    public_dir: None,
  }
  let missing = try validate_bundle(layout, Native) catch {
    Failure(_) => true
    err => raise err
  } noraise {
    _ => false
  }
  @test.assert_eq(missing, true)
}

///|
#cfg(not(platform="windows"))
async test "bundle rejects public symlink cycles before copying" {
  let dir = @fs.tmpdir(prefix="warren-bundle-symlink")
  defer @fs.rmdir(dir, recursive=true)
  @fs.symlink(
    target=dir,
    source_path_to_string(SourcePath::new(dir).join("loop")),
  )
  let rejected = try validate_bundle_tree(SourcePath::new(dir)) catch {
    Failure(_) => true
    err => raise err
  } noraise {
    _ => false
  }
  @test.assert_eq(rejected, true)
}
