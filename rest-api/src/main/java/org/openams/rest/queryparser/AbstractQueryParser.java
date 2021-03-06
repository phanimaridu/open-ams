package org.openams.rest.queryparser;

import java.sql.Time;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Stack;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.openams.rest.exception.QueryParserException;
import org.openams.rest.utils.ConverterUtil;
import org.springframework.util.Assert;

import com.querydsl.core.types.ExpressionUtils;
import com.querydsl.core.types.Ops;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.Predicate;
import com.querydsl.core.types.dsl.Expressions;

//TODO:Fix Float Path Issue
public abstract class AbstractQueryParser {

	protected final static ValueObjectAdapter EPOCH_DATE_ADAPTER = new ValueObjectAdapter(Date.class, input -> new Date(Long.parseLong(input)));
	
	protected final static ValueObjectAdapter DATE_ADAPTER = new ValueObjectAdapter(Date.class, input -> ConverterUtil.toDate(input));
	protected final static ValueObjectAdapter TIME_ADAPTER = new ValueObjectAdapter(Time.class, input -> ConverterUtil.toTime(input));
	protected final static ValueObjectAdapter DATE_TIME_ADAPTER = new ValueObjectAdapter(Date.class, input -> ConverterUtil.toDateTime(input));
	
	protected final static ValueObjectAdapter STRING_ADAPTER = new ValueObjectAdapter(String.class, input -> input);
	protected final static ValueObjectAdapter BYTE_ADAPTER = new ValueObjectAdapter(Byte.class, Byte :: parseByte);
	protected final static ValueObjectAdapter INTEGER_ADAPTER = new ValueObjectAdapter(Integer.class, Integer :: parseInt);
	protected final static ValueObjectAdapter LONG_ADAPTER = new ValueObjectAdapter(Long.class, Long :: parseLong);
	protected final static ValueObjectAdapter FLOAT_ADAPTER = new ValueObjectAdapter(Float.class, Float :: parseFloat);
	protected final static ValueObjectAdapter DOUBLE_ADAPTER = new ValueObjectAdapter(Double.class, Double :: parseDouble);
	

	private final static String KEY_PATTERN = "'(\\w|\\.|[0-9])+'";
	private final static String OPERATOR_PATTERN = "(>|<|\\=|\\!|~)\\=";
	private final static String PRESERVED_OPERATOR_PATTERN = "((?<=" + OPERATOR_PATTERN  + ")|(?=" + OPERATOR_PATTERN + "))";
	private final static String ELEMENT_PATTERN = "'(\\p{L}|[0-9]|_|-|\\.|@|%)+'";
	private final static String ARRAY_PATTERN = "\\['(\\p{L}|[0-9]|_|-|\\.|@)+'(,'(\\p{L}|[0-9]|_|-|\\.|@)+')*\\]";
	private final static String VALUE_PATTERN = "(" + ELEMENT_PATTERN + "|" + ARRAY_PATTERN + ")";
	private final static String PREDICATE_PATTERN = "\\{" + KEY_PATTERN + OPERATOR_PATTERN + VALUE_PATTERN + "\\}";
	

	protected abstract Path getEntityPath();
	
	protected abstract Map<String, ValueObjectAdapter> getKeyToAdapterMap();
	
	
	public Predicate toPredicate(String filter) throws QueryParserException{
		
		Assert.isTrue(StringUtils.isNotBlank(filter), "filter can't be empty ");
		QueryLexer lexer = new QueryLexer(filter);
		
		Stack<Term<Predicate>> termStack = new Stack<>();
		
		while(lexer.hasNext()){
			
			Term<String> lexim = lexer.next();
			
			if(lexim.getType() == Term.TYPE.RIGHT){
				
				List<Term<Predicate>> poppedTerms = new ArrayList<>();
				
				//remove till Fall back and them to list
				while (!termStack.empty() && !termStack.peek().getType().equals(Term.TYPE.LEFT)) {
					poppedTerms.add(termStack.pop());
				}
				
				//remove fallback
				if (!termStack.empty() && termStack.peek().getType().equals(Term.TYPE.LEFT)) {
					termStack.pop();
				}

				//replace all elements till LEFT with evaluated predicate
				Term<Predicate> mergedPredicateTerm = null;
				if(poppedTerms.size() == 1 && poppedTerms.get(0).getType().equals(Term.TYPE.PRDCT)){
					mergedPredicateTerm = poppedTerms.get(0);
				}else{
					mergedPredicateTerm = merge(poppedTerms);
				}
				
				termStack.push(mergedPredicateTerm);
				
			}else if(lexim.getType() == Term.TYPE.TRMNL){
				termStack.push(new Term<Predicate>(Term.TYPE.PRDCT, toLeafPredicate(lexim.getValue())));
			}else{
				termStack.push(new Term<Predicate>(lexim.getType(), null));
			}
			
		}
		
		//only 1 element allowed in stack at this point
		if(termStack.size() != 1 || ! termStack.peek().getType().equals(Term.TYPE.PRDCT)){
			throw new QueryParserException("Validation Error; Check Filter String");
		}
				
		return termStack.pop().getValue();
	}
	
	
	public Predicate toLeafPredicate(String leafFilter) throws QueryParserException{
		//validate using regEx PREDICATE_PATTERN
		if(!leafFilter.matches(PREDICATE_PATTERN)){
			throw new QueryParserException("Validation Error; Check Leaf filter String : " + leafFilter);
		}
		
		String[] tokens = leafFilter.split(PRESERVED_OPERATOR_PATTERN);
		//remove {' from start and ' from end
		String key = tokens[0].substring(2, tokens[0].length() - 1);
		String operator = tokens[1];
		//remove } from the end of value
		String rawValue = tokens[2].substring(0, tokens[2].length() - 1);
		
		if(rawValue.startsWith("[")){
			Collection<String> values = Arrays.asList(org.springframework.util.StringUtils
					.delimitedListToStringArray(rawValue.substring(1, rawValue.length() - 1), ",", "'"));
			return  toLeafPredicate(key, toArrayOperator(operator), values);
		}else{
			//removing enclosing single quotes 
			String value = rawValue.substring(1, rawValue.length() - 1);
			return  toLeafPredicate(key, toOperator(operator), value);
		}
	}
	
	protected Predicate toLeafPredicate(String key, Ops operator, Collection<String> values) throws QueryParserException {
		ValueObjectAdapter adapter = getKeyToAdapterMap().get(key);
		Path propPath = getPropertyPath(key, adapter);
		Collection<Object> objectValues = values.stream().map(input -> adapter.getObject(input)).collect(Collectors.toList());
		return Expressions.predicate(operator, propPath, Expressions.constant(objectValues));
	}

	protected Predicate toLeafPredicate(String key, Ops operator, String value) throws QueryParserException {
		ValueObjectAdapter adapter = getKeyToAdapterMap().get(key);
		Path propPath = getPropertyPath(key,adapter);
		return Expressions.predicate(operator, propPath, Expressions.constant(adapter.getObject(value)));
	}
	
	protected Path getPropertyPath(String key, ValueObjectAdapter adapter) throws QueryParserException{
		if(adapter == null){ throw new QueryParserException("Property is not supported , key : " + key); }
		return Expressions.path(adapter.getObjectType(), getEntityPath(), key);
	}
	
	protected Term<Predicate> merge(List<Term<Predicate>> tokens) throws QueryParserException {
		
		//check if size is 2n + 1 (n > 0)
		if(tokens.size() < 3 || ((tokens.size() - 1) % 2 ) != 0){
			throw new QueryParserException("Invalid number of tokens , Can't proceed with predictae merge");
		}
		
		Term<Predicate> accumilator = tokens.get(0);
		
		for (int index = 1; index < tokens.size() - 1; index = index + 2) {
			
			Term<Predicate> operator = tokens.get(index);
			Term<Predicate> rightTerm = tokens.get(index + 1);
			
			Predicate leftPredicate = accumilator.getValue();
			Predicate rightPredicate = rightTerm.getValue();
			
			if((operator.getType().equals(Term.TYPE.OR) || operator.getType().equals(Term.TYPE.AND)) &&
					rightTerm.getType().equals(Term.TYPE.PRDCT)){
				Predicate mergedPredicate =  operator.getType().equals(Term.TYPE.OR) 
						? ExpressionUtils.anyOf(leftPredicate, rightPredicate) 
						: ExpressionUtils.allOf(leftPredicate, rightPredicate);		
				accumilator = new Term<Predicate>(Term.TYPE.PRDCT, mergedPredicate);
			}else{
				throw new QueryParserException("Invalid ordering of tokens , Can't proceed with predictae merge");
			}
		}
		return accumilator;
	}
	
	protected Ops toOperator(String operatorString) throws QueryParserException{
		switch(operatorString){
			case "==" : return Ops.EQ;
			case "!="   : return Ops.NE;
			case ">="   : return Ops.GOE;
			case "<="   : return Ops.LOE;
			case "~="   : return Ops.LIKE;
			default : throw new QueryParserException("Invalid Operator : " + operatorString);		
		}
	}
	
	protected Ops toArrayOperator(String operatorString) throws QueryParserException{
		switch(operatorString){
			case "==" : return Ops.IN;
			case "!="   : return Ops.NOT_IN;
			default : throw new QueryParserException("Invalid Operator : " + operatorString);		
		}
	}
	
	public Map<String,String> getFilterConfig(){
		return getKeyToAdapterMap().entrySet().stream().collect(Collectors.toMap( e -> e.getKey(), e -> e.getValue().getObjectType().toString()));
	}
	
}


class QueryLexer {

	private final static String LEFT = "(";
	private final static String RIGHT = ")";
	private final static String AND = "&&";
	private final static String OR = "||";
	private final static String TRMNL_PATTERN = "\\{(.+)\\}";

	private char[] charData;
	private int index = 0;

	public QueryLexer(String filter) {
		String trimmedFilter = filter.replaceAll("\\s+", "");
		charData = trimmedFilter.toCharArray();
	}

	private char nextChar() {
		return charData[index++];
	}

	public Term<String> next() throws QueryParserException {

		if (hasNextChar()) {
			StringBuilder builder = new StringBuilder();
			Term<String> lexim = null;
			while ((lexim = getLexim(builder.toString())) == null && hasNextChar()) {
				builder.append(nextChar());
			}

			if (lexim != null) {
				return lexim;
			} else {
				throw new QueryParserException("Invalid Lexim : " + builder.toString());
			}
			
		} else {
			throw new QueryParserException("No more Lexims");
		}
	}
	
	public Term<String> getLexim(String input) {
		Term<String> lexim = null;
		if(input.equals(LEFT)){
			lexim = new  Term<String>(Term.TYPE.LEFT, input);
		}else if(input.equals(RIGHT)){
			lexim = new  Term<String>(Term.TYPE.RIGHT, input);
		}else if(input.equals(OR)){
			lexim = new  Term<String>(Term.TYPE.OR, input);
		}else if(input.equals(AND)){
			lexim = new  Term<String>(Term.TYPE.AND, input);
		}else if(input.matches(TRMNL_PATTERN)){
			lexim = new  Term<String>(Term.TYPE.TRMNL, input);
		}
		return lexim;
	}

	private boolean hasNextChar() {
		return (index < charData.length);
	}

	public boolean hasNext() {
		return hasNextChar();
	}

}

class Term<T> {
	
	public static enum TYPE {
		OR, AND, LEFT, RIGHT, TRMNL, PRDCT
	}
	
	private TYPE type;
	private T value;
	
	public Term(TYPE type, T value) {
		this.type = type;
		this.value = value;
	}

	public TYPE getType() {
		return type;
	}
	
	public T getValue() {
		return value;
	}

	public void setType(TYPE type) {
		this.type = type;
	}

	public void setValue(T value) {
		this.value = value;
	}
	
}

