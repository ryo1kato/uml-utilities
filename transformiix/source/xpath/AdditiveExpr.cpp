/*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 * 
 * The Original Code is TransforMiiX XSLT processor.
 * 
 * The Initial Developer of the Original Code is The MITRE Corporation.
 * Portions created by MITRE are Copyright (C) 1999 The MITRE Corporation.
 *
 * Portions created by Keith Visco as a Non MITRE employee,
 * (C) 1999 Keith Visco. All Rights Reserved.
 * 
 * Contributor(s): 
 * Keith Visco, kvisco@ziplink.net
 *   -- original author.
 *    
 * $Id: AdditiveExpr.cpp,v 1.1 2001/01/07 05:41:39 jdike Exp $
 */

/**
 * Represents a AdditiveExpr, an binary expression that
 * performs an additive operation between it's lvalue and rvalue:<BR/>
 *  +   : addition
 *  -   : subtraction
 * @author <A HREF="mailto:kvisco@ziplink.net">Keith Visco</A>
 * @version $Revision: 1.1 $ $Date: 2001/01/07 05:41:39 $
**/

#include "Expr.h"

/**
 * Creates a new AdditiveExpr using the default operator (ADDITION)
**/
AdditiveExpr::AdditiveExpr() {
    this->op = ADDITION;
    this->leftExpr  = 0;
    this->rightExpr = 0;
} //-- AdditiveExpr

/**
 * Creates a new AdditiveExpr using the given operator
**/
AdditiveExpr::AdditiveExpr(Expr* leftExpr, Expr* rightExpr, short op) {
    this->op = op;
    this->leftExpr = leftExpr;
    this->rightExpr = rightExpr;
} //-- AdditiveExpr

AdditiveExpr::~AdditiveExpr() {
    delete leftExpr;
    delete rightExpr;
} //-- ~AdditiveExpr

/**
 * Sets the left side of this AdditiveExpr
**/
void AdditiveExpr::setLeftExpr(Expr* leftExpr) {
    this->leftExpr = leftExpr;
} //-- setLeftExpr

/**
 * Sets the right side of this AdditiveExpr
**/
void AdditiveExpr::setRightExpr(Expr* rightExpr) {
    this->rightExpr = rightExpr;
} //-- setRightExpr

/**
 * Evaluates this Expr based on the given context node and processor state
 * @param context the context node for evaluation of this Expr
 * @param ps the ContextState containing the stack information needed
 * for evaluation
 * @return the result of the evaluation
**/
ExprResult* AdditiveExpr::evaluate(Node* context, ContextState* cs) {


    double rightDbl = Double::NaN;
    ExprResult* exprRes = 0;

    if ( rightExpr ) {
        exprRes = rightExpr->evaluate(context, cs);
        if ( exprRes ) rightDbl = exprRes->numberValue();
        delete exprRes;
    }

    double leftDbl = Double::NaN;
    if ( leftExpr ) {
        exprRes = leftExpr->evaluate(context, cs);
        if ( exprRes ) leftDbl = exprRes->numberValue();
        delete exprRes;
    }

    double result = 0;

    switch ( op ) {
        case SUBTRACTION:
            result = leftDbl - rightDbl;
            break;
        default:
            result = leftDbl + rightDbl;
            break;
    }
   return new NumberResult(result);
} //-- evaluate

/**
 * Returns the String representation of this Expr.
 * @param dest the String to use when creating the String
 * representation. The String representation will be appended to
 * any data in the destination String, to allow cascading calls to
 * other #toString() methods for Expressions.
 * @return the String representation of this Expr.
**/
void AdditiveExpr::toString(String& str) {

    if ( leftExpr ) leftExpr->toString(str);
    else str.append("null");

    switch ( op ) {
        case SUBTRACTION:
            str.append(" - ");
            break;
        default:
            str.append(" + ");
            break;
    }
    if ( rightExpr ) rightExpr->toString(str);
    else str.append("null");

} //-- toString
