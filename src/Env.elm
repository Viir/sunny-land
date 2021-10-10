module Env exposing (..)

import CompilationInterface.SourceFiles


{-| A trick to be able to deploy assets with full URL.
-}
baseUrl =
    ""


fullUrlFromRelativePath : String -> String
fullUrlFromRelativePath pathAsString =
    let
        continueWithFileTree fileTree =
            getBlobAtPathInFileTree fileTree
                >> Maybe.map (.base64 >> buildUrlFromBase64)
                >> Maybe.withDefault ""

        pathElements =
            List.filter (String.isEmpty >> not) (String.split "/" pathAsString)
    in
    case pathElements of
        "assets" :: pathInAssets ->
            continueWithFileTree CompilationInterface.SourceFiles.file_tree____assets_for_runtime pathInAssets

        _ ->
            baseUrl ++ pathAsString


buildUrlFromBase64 : String -> String
buildUrlFromBase64 base64 =
    "data:;base64," ++ base64


getBlobAtPathInFileTree : CompilationInterface.SourceFiles.FileTreeNode b -> List String -> Maybe b
getBlobAtPathInFileTree fileTree subpath =
    fileTree
        |> listAllFilesFromSourceFileTreeNode
        |> List.filter (Tuple.first >> (==) subpath)
        |> List.head
        |> Maybe.map Tuple.second


listAllFilesFromSourceFileTreeNode : CompilationInterface.SourceFiles.FileTreeNode a -> List ( List String, a )
listAllFilesFromSourceFileTreeNode node =
    case node of
        CompilationInterface.SourceFiles.BlobNode blob ->
            [ ( [], blob ) ]

        CompilationInterface.SourceFiles.TreeNode tree ->
            tree
                |> List.concatMap
                    (\( entryName, entryNode ) ->
                        listAllFilesFromSourceFileTreeNode entryNode |> List.map (Tuple.mapFirst ((::) entryName))
                    )
