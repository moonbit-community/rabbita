///|
using @path {type SourcePath}

///|
pub(all) enum VirtualFs {
  DirectoryMapping(SourcePath)
  FileMapping(SourcePath)
  DirectoryContent(Map[String, VirtualFs])
  FileContent(String)
} derive(Debug)

///|
struct VirtualFileSystem {
  roots : Map[String, VirtualFs]
} derive(Debug)

///|
#as_free_fn
pub fn VirtualFileSystem::new(map : Map[String, VirtualFs]) -> Self {
  let self = { roots: Map([]), }
  for entry in map.iter() {
    let (path, node) = entry
    self.mount(path, node)
  }
  self
}

///|
pub fn VirtualFileSystem::mount(
  self : Self,
  path : String,
  vfs : VirtualFs,
) -> Unit {
  let parts = path
    .split("/")
    .map(part => part.to_owned())
    .filter(part => part != "")
    .collect()
  guard !parts.is_empty() else {
    self.roots[""] = vfs
    return
  }

  let mut entries = self.roots
  for i in 0..<(parts.length() - 1) {
    let name = parts[i]
    let next = match entries.get(name) {
      Some(DirectoryContent(children)) => children
      Some(_) => {
        println("Cannot mount inside a non-directory node.")
        panic()
      }
      None => {
        let children = Map([])
        entries[name] = DirectoryContent(children)
        children
      }
    }
    entries = next
  }
  entries[parts[parts.length() - 1]] = vfs
}

///|
pub fn VirtualFileSystem::unmount(self : Self, path : String) -> Unit {
  let parts = path
    .split("/")
    .map(part => part.to_owned())
    .filter(part => part != "")
    .collect()
  guard !parts.is_empty() else {
    self.roots.remove("")
    return
  }

  fn remove(entries : Map[String, VirtualFs], i : Int) -> Unit {
    entries.update(parts[i], fn(node) {
      match node {
        Some(node) =>
          if i + 1 == parts.length() {
            None
          } else {
            match node {
              DirectoryContent(children) => {
                remove(children, i + 1)
                if children.is_empty() {
                  None
                } else {
                  Some(DirectoryContent(children))
                }
              }
              _ => Some(node)
            }
          }
        None => None
      }
    })
  }

  remove(self.roots, 0)
}

///|
pub fn VirtualFileSystem::clear(self : Self) -> Unit {
  self.roots.clear()
}

///|
pub async fn VirtualFileSystem::read(self : Self, path : String) -> &@io.Data? {
  let parts = path
    .split("/")
    .map(part => part.to_owned())
    .filter(part => part != "")
    .collect()
  guard parts.iter().all(fn(p) { p != ".." }) else { return None }
  let (current, i) = match parts {
    [] =>
      match self.roots.get("") {
        Some(root) => (root, 0)
        None => return None
      }
    [first, ..] =>
      match self.roots.get(first) {
        Some(root) => (root, 1)
        None =>
          match self.roots.get("") {
            Some(root) => (root, 0)
            None => return None
          }
      }
  }
  let mut current = current
  let mut i = i
  while i < parts.length() {
    match current {
      DirectoryContent(entries) =>
        match entries.get(parts[i]) {
          Some(next) => {
            current = next
            i += 1
          }
          None => return None
        }
      DirectoryMapping(path) => {
        let mut file = path
        for j in i..<parts.length() {
          file = file.join(parts[j])
        }
        current = FileMapping(file)
        i = parts.length()
      }
      _ => return None
    }
  }

  match current {
    FileContent(content) => Some(content)
    FileMapping(path) => {
      guard @fs.exists(path.to_string()) &&
        @fs.kind(path.to_string()) is Regular else {
        return None
      }
      Some(@fs.read_file(path.to_string()))
    }
    _ => None
  }
}
