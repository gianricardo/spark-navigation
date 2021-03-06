#!/bin/sh

FILE=$1
SUM=0
OK_SUM=0

# Textual output
echo "VCs statistics:"
for i in precondition postcondition "loop invariant" "loop variant" assertion division overflow range index discriminant; do
  CNT=`grep "${i}" ${FILE} | grep -v "saved VC" | wc -l`
  OK=` grep "${i}" ${FILE} | grep -v "saved VC" | grep -v "not proved" | wc -l`
  echo ${i} ${OK}/${CNT}
  SUM=`expr ${SUM} + ${CNT}`
  OK_SUM=`expr ${OK_SUM} + ${OK}`
done

echo
echo Total: ${OK_SUM}/${SUM}

# LaTeX table output
echo "LaTeX table line:"
for i in precondition postcondition "loop invariant" "loop variant" assertion division int_overflow float_overflow range index discriminant; do
  CNT=`grep "${i}" ${FILE} | grep -v "saved VC" | wc -l`
  echo -n " & ${CNT}"
done

echo -n " & {\\\\bf ${SUM}} \\\\\\\\"
echo

echo

INTEGER_OVERFLOWS=`grep "\"GP_Reason:VC_OVERFLOW_CHECK\" \"GP_Sloc_VC:[a-zA-Z_-]\+.ad[bs]:[0-9]\+:[0-9]\+\" \"keep_on_simp\" (Standard__integer" algorithm/obj/gnatprove/*.mlw -o |uniq|wc -l`
CONTAINER_OVERFLOWS=`grep "\"GP_Reason:VC_OVERFLOW_CHECK\" \"GP_Sloc_VC:[a-zA-Z_-]\+.ad[bs]:[0-9]\+:[0-9]\+\" \"keep_on_simp\" (Ada__container" algorithm/obj/gnatprove/*.mlw -o |uniq|wc -l`
FLOAT_OVERFLOWS=`grep "\"GP_Reason:VC_OVERFLOW_CHECK\" \"GP_Sloc_VC:[a-zA-Z_-]\+.ad[bs]:[0-9]\+:[0-9]\+\" \"keep_on_simp\" (Standard__float" algorithm/obj/gnatprove/*.mlw -o |uniq|wc -l`

TOTAL_INT_OVERFLOWS=`expr ${INTEGER_OVERFLOWS} + ${CONTAINER_OVERFLOWS}`

echo "integer overflows: ${INTEGER_OVERFLOWS} + ${CONTAINER_OVERFLOWS} = ${TOTAL_INT_OVERFLOWS}"
echo "floating-point overflows: ${FLOAT_OVERFLOWS}"
TOTAL_OVERFLOWS=`expr ${INTEGER_OVERFLOWS} + ${FLOAT_OVERFLOWS}`
echo "total overflows: ${TOTAL_OVERFLOWS}"
