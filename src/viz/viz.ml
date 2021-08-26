open Ast
open Big_int

type node_t =
  | NInt of string
  | NBinOp of string

module Node = struct
   type t = node_t * int
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

let node_t_constructor expr =
   match expr with
   | EInt n -> NInt (string_of_big_int n)
   | EBinOp(_, BPlus, _) -> NBinOp "+"
   | EBinOp(_, BMinus, _) -> NBinOp "-"
   | EBinOp(_, BTimes, _) -> NBinOp "*"
   | EBinOp(_, BDiv, _) -> NBinOp "/"

let label_of_node_t expr lst =
  let label = match expr with
   | NInt n -> n
   | NBinOp op -> op
  in `Label label :: lst

let shape_of_node_t expr lst =
   let shape = match expr with
   | NInt _ -> `Box
   | NBinOp _ -> `Oval
in `Shape shape :: lst

let style_of_node_t expr lst =
   match expr with
   | NInt _ -> `Style `Filled :: lst
   | _ -> lst

let vertex_attr (expr : node_t) : Graph.Graphviz.DotAttributes.vertex list =
  label_of_node_t expr [] |> shape_of_node_t expr |> style_of_node_t expr

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
   let n = node_t_constructor expr in
   match expr with
   | EInt _ -> (* Terminal Node *)
      let vertex = G.V.create (n, id) in
      let g' = G.add_vertex g vertex in
      (g', vertex)
   | EBinOp(l, _, r) ->
      let bin_op_vertex = G.V.create (n, id) in
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
  print_endline "Success! Open 'mygraph.png' to see your visualized expr."

