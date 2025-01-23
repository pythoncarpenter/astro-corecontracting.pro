#!/bin/zsh

typeset -A component_tree
typeset -A component_imports  
typeset -A typescript_exports
typeset -A component_data
typeset -A shared_data

BLUE=$'\033[0;34m'
GREEN=$'\033[0;32m'  
YELLOW=$'\033[1;33m'
NC=$'\033[0m'

analyze_component() {
    local file="$1"
    local component_name=${file##*/}
    component_name=${component_name%.astro}
    echo "${BLUE}Analyzing Component: ${component_name}${NC}"
    
    while IFS= read -r line; do
        if [[ $line =~ "import.*from.*[\"']([\.\/][^\"']+)[\"']" ]]; then
            local import_path=$match[1]
            local imported_component=${import_path##*/}
            imported_component=${imported_component%.astro}
            component_imports[$component_name]+="$imported_component;"
            component_tree[$imported_component]+="$component_name;"
        fi

        if [[ $line =~ "<([A-Z][a-zA-Z0-9]*).*>" ]]; then
            local used_component=$match[1]
            component_data[$component_name]+="uses:$used_component;"
        fi

        if [[ $line =~ "getElementById\('([^']+)'\)" ]]; then
            local element_id=$match[1]
            component_data[$component_name]+="binds:$element_id;"
        fi
    done < "$file"
}

analyze_typescript() {
    local file="$1"
    local filename=${file##*/}
    filename=${filename%.ts}
    echo "${GREEN}Analyzing TypeScript: ${filename}${NC}"

    while IFS= read -r line || [[ -n $line ]]; do 
        if [[ $line =~ ^[[:space:]]*export[[:space:]]+(async[[:space:]]+)?function[[:space:]]+([a-zA-Z][a-zA-Z0-9]*) ]]; then
            local func_name=$match[2]
            typescript_exports[$filename]+="$func_name;"
        fi

        if [[ $line =~ "const[[:space:]]+([a-zA-Z][a-zA-Z0-9]*)[[:space:]]*=" ]]; then
            local const_name=$match[1]
            shared_data[$filename]+="$const_name;"
        fi
    done < "$file" 
}

print_flow_analysis() {
    print "\nComponent Flow Analysis"
    print "====================="
     
    print "\n${BLUE}Component Hierarchy:${NC}"
    for component in ${(k)component_tree}; do
        print "Component: $component"
        IFS=';' read -A PARENTS <<< "${component_tree[$component]}"
        for parent in $PARENTS; do
            [[ -n $parent ]] && print "  └─ Used by: $parent"  
        done
    done

    print "\n${YELLOW}Data Flow:${NC}"
    for component in ${(k)component_data}; do 
        print "Component: $component"
        IFS=';' read -A DATA <<< "${component_data[$component]}"
        for flow in $DATA; do
            [[ -n $flow ]] && print "  └─ $flow"
        done
    done

    print "\n${GREEN}TypeScript Functions:${NC}"
    for file in ${(k)typescript_exports}; do
        print "Module: $file"
        IFS=';' read -A FUNCTIONS <<< "${typescript_exports[$file]}" 
        for func in $FUNCTIONS; do
            [[ -n $func ]] && print "  └─ Exports: $func"
        done
    done

    print "\n${GREEN}Shared Data:${NC}"
    for file in ${(k)shared_data}; do
        print "Module: $file"  
        IFS=';' read -A CONSTANTS <<< "${shared_data[$file]}"
        for const in $CONSTANTS; do 
            [[ -n $const ]] && print "  └─ Constant: $const"
        done
    done
}

print "Project Flow Analysis"
print "==================="

find ./src -name "*.astro" -type f -print0 | while IFS= read -r -d $'\0' file; do
    analyze_component "$file"
done

find ./src -name "*.ts" -not -path "*/api/*" -type f -print0 | while IFS= read -r -d $'\0' file; do
    analyze_typescript "$file"  
done

print_flow_analysis