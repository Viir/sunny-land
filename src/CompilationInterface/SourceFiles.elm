module CompilationInterface.SourceFiles exposing (..)


type FileTreeNode blobStructure
    = BlobNode blobStructure
    | TreeNode (List ( String, FileTreeNode blobStructure ))


file_tree____assets_for_runtime : FileTreeNode { base64 : String }
file_tree____assets_for_runtime =
    BlobNode { base64 = "The compiler replaces this value." }
