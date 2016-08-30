module lang::php::analysis::cfg::Util

import lang::php::ast::AbstractSyntax;
import lang::php::analysis::cfg::CFG;
import lang::php::analysis::cfg::FlowEdge;
import lang::php::analysis::cfg::BasicBlocks;
import analysis::graphs::Graph;
import Relation;
import Set;

public set[CFGNode] pred(CFG cfg, CFGNode n) {
	predlabels = { e.from | e <- cfg.edges, e.to == n@lab };
	return { nd | nd <- cfg.nodes, nd@lab in predlabels };
}

public set[CFGNode] pred(Graph[CFGNode] g, CFGNode n) = invert(g)[n];

public set[CFGNode] succ(CFG cfg, CFGNode n) {
	succlabels = { e.to | e <- cfg.edges, e.from == n@lab };
	return { nd | nd <- cfg.nodes, nd@lab in succlabels };
}

public set[CFGNode] succ(Graph[CFGNode] g, CFGNode n) = g[n];

public set[CFGNode] reachable(Graph[CFGNode] g, CFGNode n) = g+[n];

public set[CFGNode] reaches(Graph[CFGNode] g, CFGNode n) = (invert(g)+)[n];

public CFGNode findNodeForExpr(CFG cfg, Expr expr) {
	possibleMatches = { n | n:exprNode(e) <- cfg.nodes, e == expr, (e@at)?, (expr@at)?, e@at == expr@at };
	if (size(possibleMatches) == 1) {
		return getOneFrom(possibleMatches);
	} else if (size(possibleMatches) > 1) {
		throw "Unexpected error: multiple matching expressions found";
	} else {
		throw "Unexpected error: no matching expressions found";
	}
}

public CFGNode findNodeForStmt(CFG cfg, Stmt stmt) {
	possibleMatches = { n | n:stmtNode(s) <- cfg.nodes, s == stmt, (s@at)?, (stmt@at)?, s@at == stmt@at };	
	if (size(possibleMatches) == 1) {
		return getOneFrom(possibleMatches);
	} else if (size(possibleMatches) > 1) {
		throw "Unexpected error: multiple matching statements found";
	} else {
		throw "Unexpected error: no matching statements found";
	}
}
