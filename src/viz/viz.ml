open Ast
open Big_int

module Node = struct
  type t = expr * int

  (* This will preserve the order of nodes, which will preserve the order of operation in the graph *)
  let compare (_, id1) (_, id2) = compare id1 id2

  let hash = Hashtbl.hash

  let equal = ( = )
end

module Edge = struct
  type t = string

  let compare = compare

  let equal = ( = )

  let default = ""
end

module G = Graph.Persistent.Digraph.ConcreteBidirectionalLabeled (Node) (Edge)

let label_of_expr expr lst =
  let label =
    match expr with
    | EInt n -> string_of_big_int n
    | EBinOp (_, BPlus, _) -> "+"
    | EBinOp (_, BMinus, _) -> "-"
    | EBinOp (_, BTimes, _) -> "*"
    | EBinOp (_, BDiv, _) -> "/"
  in
  `Label label :: lst

let shape_of_expr expr lst =
  let shape =
    match expr with
    | EInt _ -> `Box
    | EBinOp _ -> `Oval
  in
  `Shape shape :: lst

let style_of_expr expr lst =
  match expr with
  | EInt _ -> `Style `Filled :: lst
  | _ -> lst

let vertex_attr (expr : expr) : Graph.Graphviz.DotAttributes.vertex list =
  label_of_expr expr [] |> shape_of_expr expr |> style_of_expr expr

(* Graphviz.DotAttributes : http://ocamlgraph.lri.fr/doc/Graphviz.DotAttributes.html#TYPEgraph *)
module Dot = Graph.Graphviz.Dot (struct
  include G (* use the graph module from above *)

  let edge_attributes (_, e, _) = [ `Label e; `Color 4711 ]

  let default_edge_attributes _ = []

  let get_subgraph _ = None

  let vertex_attributes (e, _) = vertex_attr e

  let vertex_name (_, id) = string_of_int id

  let default_vertex_attributes _ = []

  let graph_attributes _ = []
end)

let fresh =
  let counter = ref 0 in
  fun () ->
    counter := !counter + 1;
    !counter

let rec generate_graph (g : G.t) (expr : expr) =
  let id = fresh () in
  match expr with
  | EInt _ ->
    (* Terminal Node *)
    let vertex = G.V.create (expr, id) in
    let g' = G.add_vertex g vertex in
    (g', vertex)
  | EBinOp (l, _, r) ->
    let bin_op_vertex = G.V.create (expr, id) in
    let g = G.add_vertex g bin_op_vertex in
    let g, lv = generate_graph g l in
    let g, rv = generate_graph g r in
    let g = G.add_edge g bin_op_vertex lv in
    let g = G.add_edge g bin_op_vertex rv in
    (g, bin_op_vertex)

let g = G.empty

let write_expr_to_graphviz (expr_opt : expr option) : unit =
  let name = "mygraph.dot" in
  match expr_opt with
  | Some expr ->
    let g, _ = generate_graph g expr in
    let file = open_out_bin name in
    Dot.output_graph file g;
    let _ = Sys.command (Printf.sprintf "dot %s -Tpng -o mygraph.png && rm %s" name name) in
    print_endline "Success! Open 'mygraph.png' to see your visualized expr."
  | None -> print_endline "Invalid expression"
