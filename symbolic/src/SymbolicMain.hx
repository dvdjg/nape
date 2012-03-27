package;

import symbolic.Expr;
using symbolic.Expr.ExprUtils;

class SymbolicMain {
	static function bodyContext(context:Context, body:Int) {
		context.variableContext("pos"+body,etVector,eVariable("ve1"+body));
		context.variableContext("vel"+body,etVector);
		context.variableContext("rot"+body,etScalar,eVariable("angvel"+body));
		context.variableContext("angvel"+body,etScalar);
		context.variableContext("imass"+body,etScalar);
		context.variableContext("iinertia"+body,etScalar);
	}

	static function main() {
		var txt = new flash.text.TextField();
		var c = flash.Lib.current.stage;
		c.addChild(txt);
		txt.width = c.stageWidth;
		txt.height = c.stageHeight;
		txt.wordWrap = true;

		function tracex(x:Dynamic) {
			txt.text += Std.string(x)+"\n";
		}

		var context = ExprUtils.emptyContext();
		context.variableContext("anchor1",etVector);
		context.variableContext("anchor2",etVector);
		bodyContext(context,1);
		bodyContext(context,2);

		var expr = eLet(
			"a",eCross(eScalar(10),eVariable("pos1")),
			eOuter(eVariable("a"),eVariable("a"))
		);

		tracex(expr.print());
	
		function wrap(e:Expr) {
			return
			eLet("pos1",eVector(1,2),
			eLet("pos2",eVector(2,1),
			eLet("rot1",eScalar(Math.PI*0.5),
			eLet("rot2",eScalar(Math.PI),
			eLet("vel1",eVector(10,20),
			eLet("vel2",eVector(20,10),
			eLet("angvel1",eScalar(1),
			eLet("angvel2",eScalar(-1),
			eLet("anchor1",eVector(1,0),
			eLet("anchor2",eVector(0,1),
				e
			))))))))));
		}
	
		var evalexpr = eLet(
			"pos1",eVector(1,20),
			expr
		);
		tracex(evalexpr.print());
		tracex(evalexpr.eval(context).print());

		var expr = eLet(
			"a",eRelative("rot1",eVariable("anchor1")),
			eLet("b",eVariable("a"),
				eOuter(eVariable("b"),eUnit(eVariable("a")))
			)
		);
		tracex(expr.print());
		tracex(expr.diff(context).print());
		tracex(wrap(expr).eval(context).print());
		tracex(wrap(expr.diff(context)).eval(context).print());
	}
/*
	static function main() {
		var space = new nape.space.Space();

		var b1 = new nape.phys.Body();
		b1.shapes.add(new nape.shape.Circle(20));
		var b2 = new nape.phys.Body(nape.phys.BodyType.KINEMATIC);
		b2.shapes.add(new nape.shape.Circle(20));

		b1.shapes.at(0).filter = new nape.dynamics.InteractionFilter(1,2);
		b2.shapes.at(0).filter = new nape.dynamics.InteractionFilter(2,1);

		b1.space = b2.space = space;

		b1.cbType = new nape.callbacks.CbType();
		b2.cbType = new nape.callbacks.CbType();

		space.listeners.add(new nape.callbacks.InteractionListener(nape.callbacks.CbEvent.BEGIN, nape.callbacks.InteractionType.COLLISION, b1.cbType, b2.cbType, function (cb) { trace(cb); }));
		
		space.step(1);
	}*/
}
