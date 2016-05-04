;;define os tipos de agentes
breed [ vants ]
breed [ pois ]

patches-own [
  chemical
]

;;declara-se as variáveis globais necessárias

;;implementa-se os métodos principais
to inicializar
  ;;chama o método reset
  reset
  ;;define os pois
  create-pois mum-pontos-interesse[
    set shape "car top" ;;define a aparencia dos pois
    set size 4
    set color green
    setxy (min-pxcor + 2) (max-pycor - 5)
  ]
  ;;define os vants
  create-vants num-vants [
    set shape "vant" ;;define o estilo criado para representar os vants
    set size 4 ;;define o tamsnho dos vants
    set color black ;;define a cor padrão dos vants
    setxy pxcor pycor ;;oloca os vants no cenário
    ;;pd ;;faz com que os vants trassem sua rota
  ]
end

to reset
  ;;limpa tudo
  ca
  ;;inicializa as variaveis
  set num-vants 4
  set mum-pontos-interesse 4
  reset-ticks
  ;;pinta os patches de marrom
  ask patches[
    set pcolor brown
  ]
end

to executar
  ask vants[
    if (chemical >= 0.1)[
      uphill-chemical
    ]
    fd 1
  ]
  ask pois[
    move-poi
  ]
  diffuse chemical taxa-de-difusao
  ask patches [
    set chemical chemical * (100 - taxa-de-evaporacao) / 100
    recolor-patch
  ]
  tick
end

;;implementa-se os métodos secundários

to move-poi
    fd 1
    set chemical chemical + 10
end

to recolor-patch
  ifelse chemical > 1[
    set pcolor scale-color green chemical 5 0.1
  ][
    set pcolor brown
  ]
end

to uphill-chemical
  let scent-ahead chemical-scent-at-angle   0
  let scent-right chemical-scent-at-angle  45
  let scent-left  chemical-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)[
    ifelse scent-right > scent-left[
      rt 45
    ][
      lt 45
    ]
  ]
end

to-report chemical-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [
    report 0
  ]
  report [chemical] of p
end
