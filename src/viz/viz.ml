open Ast

module Node = struct
   type t = expr * int
   let compare = compare
   let hash = Hashtbl.hash
   let equal = (=)
end

module Edge = struct
   type t = string
   let compare = compare
   let equal = (=)
   let default = ""
end

module G =  Graph.Persistent.Digraph.ConcreteBidirectionalLabeled(Node)(Edge)

let label_of_expr_type expr lst =
   let label = match expr with
   | EInt n -> (string_of_int n)
   | EBinOp(_, BPlus, _) -> "+"
   | EBinOp(_, BMinus, _) -> "-"
   | EBinOp(_, BTimes, _) -> "*"
   | EBinOp(_, BDiv, _) -> "/"
in `Label label :: lst

let shape_of_expr_type expr lst =
   let shape = match expr with
   | EInt _ -> `Box
   | EBinOp(_, BPlus, _) -> `Oval
   | EBinOp(_, BMinus, _) -> `Oval
   | EBinOp(_, BTimes, _) -> `Oval
   | EBinOp(_, BDiv, _) -> `Oval
in `Shape shape :: lst

let style_of_expr_type expr lst =
   match expr with
   | EInt _ -> `Style `Filled :: lst
   | _ -> lst

let vertex_attr (expr : expr) : Graph.Graphviz.DotAttributes.vertex list =
   label_of_expr_type expr [] |> shape_of_expr_type expr |> style_of_expr_type expr

module Dot = Graph.Graphviz.Dot(struct
   include G (* use the graph module from above *)
   let edge_attributes (_, e, _) = [`Label e; `Color 4711]
   let default_edge_attributes _ = []
   let get_subgraph _ = None
   let vertex_attributes (e, _) = vertex_attr e
   let vertex_name (_, id) = string_of_int id
   let default_vertex_attributes _ = []
  let graph_attributes _ = []
end)


let fresh =
   let counter = ref 0 in
   (fun () ->
      counter := !counter + 1; !counter)

let rec generate_graph (g : G.t) (expr : expr) =
   let id = fresh () in
   match expr with
   | EInt _ -> (* Terminal Node *)
      let vertex = G.V.create (expr, id) in
      let g' = G.add_vertex g vertex in
      (g', vertex)
   | EBinOp(l, _, r) ->
      let bin_op_vertex = G.V.create (expr, id) in
      let g = G.add_vertex g bin_op_vertex in
      let (g, lv) = generate_graph g l in
      let (g, rv) = generate_graph g r in
      let g = G.add_edge g bin_op_vertex lv in
      let g = G.add_edge g bin_op_vertex rv in
      (g, bin_op_vertex)

let g = G.empty

let write_expr_to_graphviz (expr : expr) : unit =
  let name = "mygraph.dot" in
  let (g, _) = generate_graph g expr in
  let file = open_out_bin name in
  Dot.output_graph file g;
  let _ = Sys.command (Printf.sprintf "dot %s -Tpng -o mygraph.png && rm %s" name name) in
  ()

