import React from 'react';
import PengineClient from './PengineClient';
import Board from './Board';
import RadioButton from './RadioButton';
import { queryByTestId } from '@testing-library/dom';

class Game extends React.Component {

  pengine;

  constructor(props) {
    super(props);
    this.state = {
      grid_aux: null,
      grid: null,
      rowClues: null,
      colClues: null,
      waiting: false,
      opcion: '#',
      satisfaccion_filas: [],
      satisfaccion_cols: [],
      victoria: false,
      tablero_solucion_off: true,
      revelar_celda_on: false
    };
    this.onValueChange = this.onValueChange.bind(this);
    this.handleClick = this.handleClick.bind(this);
    this.handlePengineCreate = this.handlePengineCreate.bind(this);
    this.mostrarSolucion = this.mostrarSolucion.bind(this);
    this.descubrirCelda = this.descubrirCelda.bind(this);
    this.pengine = new PengineClient(this.handlePengineCreate);
  }

  handlePengineCreate() {
    let queryS = 'init(PistasFilas, PistasColumns, Grilla), generarTableroSolucion(PistasFilas, PistasColumns, Grilla, GrillaSolucion)';
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          grid: response['Grilla'],
          rowClues: response['PistasFilas'],
          colClues: response['PistasColumns']
        });

        let satisfaccion_filas_aux = [];
        let satisfaccion_cols_aux = [];

        for(let i=0; i<this.state.grid.length; i++){
          satisfaccion_filas_aux[i] = 0;
          satisfaccion_cols_aux[i] = 0;
        }

        this.setState({
          satisfaccion_filas: satisfaccion_filas_aux,
          satisfaccion_cols: satisfaccion_cols_aux
        }
        );

      }
    });
  }

  handleClick(i, j) {
    // No action on click if we are waiting.
    if (this.state.waiting) {
      return;
    }
    // Build Prolog query to make the move, which will look as follows:
    // put("#",[0,1],[], [],[["X",_,_,_,_],["X",_,"X",_,_],["X",_,_,_,_],["#","#","#",_,_],[_,_,"#","#","#"]], GrillaRes, FilaSat, ColSat)
    // const squaresS = JSON.stringify(this.state.grid).replaceAll('"_"', "_"); // Remove quotes for variables.
    
    const squaresS = JSON.stringify(this.state.grid).replaceAll('"_"', '_')

    let cambio_realizado = false;
    let pistas_filas = this.formatear_pista(this.state.rowClues);
    let pistas_columnas = this.formatear_pista(this.state.colClues);

    let queryS = null;
    
    if (!this.state.revelar_celda_on){
        queryS = 'put("' + this.state.opcion + '", [' + i + ',' + j + ']' 
           + ', ' + pistas_filas + ', ' + pistas_columnas + ',' + squaresS + ', GrillaRes, FilaSat, ColSat)';
    }
    else{
      //revelarCelda(Grilla, [RowN, ColN], PistasFilas, PistasColumnas, NewGrilla, FilaSat, ColSat, ResultadoOp)
        queryS = 'revelarCelda(' + squaresS + ', [' + i + ',' + j + ']' 
          + ', ' + pistas_filas + ', ' + pistas_columnas + ', GrillaRes, FilaSat, ColSat, ResultadoOp)';
    }

    console.log(queryS);

    this.setState({
      waiting: true
    });
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          grid: response['GrillaRes'],
          waiting: false
        });

        if (this.state.revelar_celda_on){
          cambio_realizado = (response['ResultadoOp']===1) ? true : false;
        }

        let satisfaccion_filas_aux = this.state.satisfaccion_filas;
        let satisfaccion_cols_aux = this.state.satisfaccion_cols;

        if (this.state.revelar_celda_on){
          if (cambio_realizado){
            satisfaccion_filas_aux[i] = response['FilaSat'];
            satisfaccion_cols_aux[j] = response['ColSat'];
          }
        }
        else{
          satisfaccion_filas_aux[i] = response['FilaSat'];
          satisfaccion_cols_aux[j] = response['ColSat'];
        }
        
        this.setState({
          satisfaccion_filas: satisfaccion_filas_aux,
          satisfaccion_cols: satisfaccion_cols_aux,
          victoria: this.ganado(this.state.satisfaccion_filas, this.state.satisfaccion_cols)
        });
        
        if (this.state.revelar_celda_on){
          this.setState({
            revelar_celda_on: false
          });
          let texto = (cambio_realizado) ? "Valor revelado en la celda ("+ i + ", " + j + ")" : "No se puede revelar el valor de una celda no vacía.";
          alert(texto);
        }

      } else {
        this.setState({
          waiting: false
        });
      }
    });
  }

  /**
   * Manejador de eventos de RadioButton
   * @param {} event Evento capturado
   */
  onValueChange(event){
    this.setState({
        opcion: event.target.value
    });
  }

/**
 * Reemplaza un caracter de una cadena por otro dado, dado un índice
 * @param {*} data Cadena de caracteres original
 * @param {*} index Índice donde se encuentra el caracter a reemplazar
 * @param {*} replaceMent Caracter dado para reemplazar el anterior
 * @returns Nueva cadena de caracteres con el nuevo caracter en lugar del anterior
 */
replaceUsingIndex(data,index,replaceMent){
  if(index >= data.length) return data;

  return data.substring(0,index)+replaceMent+data.substring(index+1)
}

/**
 * Dada una pista en formato de pengines, devuelve una cadena representando
 * esa pista como una listas de listas al estilo Prolog
 * @param {*} pista_bruto Pista en formato de pengines (array list)
 * @returns Una cadena representando la pista como una listas de listas al 
 * estilo Prolog
 */
formatear_pista(pista_bruto){
  let pistas_formateada = "[";
  let pista_unitaria = "";
  pista_bruto.forEach(pista => {
    pista_unitaria = "["
    pista.forEach(p => {
      pista_unitaria += p + ",";
    });
    pista_unitaria = this.replaceUsingIndex(pista_unitaria, pista_unitaria.length-1, ']');
    pistas_formateada += pista_unitaria + ",";
  });  
  pistas_formateada = this.replaceUsingIndex(pistas_formateada, pistas_formateada.length-1, ']');
  
  return pistas_formateada;
}

/**
 * Analiza el estado de satisfacción de las filas y de las columnas y retorna
 * verdadero si se satisfacen todas las pistas, falso en caso contrario
 * @param {*} satisfaccion_filas Arreglo con el estado de satisfacción de las
 * pistas de las filas
 * @param {*} satisfaccion_cols Arreglo con el estado de satisfacción de las
 * pistas de las columnas
 * @returns Verdadero si se satisfacen todas las pistas, falso en caso contrario
 */
ganado(satisfaccion_filas, satisfaccion_cols){
  let filas_satisfechas = true;
  let i = 0;
  while(filas_satisfechas && i<satisfaccion_filas.length){
    filas_satisfechas = (satisfaccion_filas[i] === 1);
    i++;
  }

  let cols_satisfechas = true;
  if(filas_satisfechas){
    i = 0;
    while(cols_satisfechas && i<satisfaccion_cols.length){
      cols_satisfechas = (satisfaccion_cols[i] === 1);
      i++;
    }
  }

  return (filas_satisfechas && cols_satisfechas);
}

mostrarSolucion(){
    if (this.state.revelar_celda_on){
        alert("No se puede mostrar el tablero solución estando activada la función reveldar boton");
    }
    else{
      this.setState({
        tablero_solucion_off: !this.state.tablero_solucion_off
        }
      )
      //Si se debe mostrar el tablero solucion, entonces reemplazar grilla por su solucion
      if (this.state.tablero_solucion_off){
        const queryS = 'grillaSolucion(GrillaSolucion)';      
        this.pengine.query(queryS, (success, response) => {
          if (success) {
            this.setState({
              grid_aux: this.state.grid,
              grid: response['GrillaSolucion'],
              waiting: true //Desabilita el clickeado de los cuadrados
            });
          }
        });
      }
      else{
        this.setState({
          grid: this.state.grid_aux,
          grid_aux: null,
          waiting: false //Habilita el clickeado de los cuadrados
        })
      }
    }
}

descubrirCelda(){
  let texto = (this.state.tablero_solucion_off) ? "Seleccione una casilla vacía para revelar su valor" : "Para revelar una celda, primero debe ocultar el tablero solución";
  alert(texto);
  if (this.state.tablero_solucion_off){
    this.setState({
      revelar_celda_on: true
    });
  }

  
}

  render() {
    if (this.state.grid === null) {
      return null;
    }
    
    let statusText = 'Keep playing!';
    if(this.state.victoria){
      statusText = 'Has ganado!';
    }

    let textoBotonSolucion = (this.state.tablero_solucion_off) ? "Mostrar solución" : "Ocultar solución";
    let textoBotonCelda = (this.state.revelar_celda_on) ? "Revelando celda" : "Revelar celda";

    return (
      <div className="global">
        <div className="game">
          <Board
            grid={this.state.grid}
            rowClues={this.state.rowClues}
            colClues={this.state.colClues}
            onClick={(i, j) => this.handleClick(i,j)}

            seguir_jugando = {!this.state.victoria}
            satisfaccion_filas = {this.state.satisfaccion_filas}
            satisfaccion_cols = {this.state.satisfaccion_cols}
          />
          <div className="gameInfo">
            {statusText}
          </div>
        </div>
          <div className="selectorOpcion">
            <RadioButton
              value = 'X'
              checked = {this.state.opcion === 'X'}
              onChange = {this.onValueChange}
              contenido = "X"
            />
            <RadioButton
              value = '#'
              checked = {this.state.opcion === '#'}
              onChange = {this.onValueChange}
              contenido = "◼"
            />
          </div>
          
          <div className="buttonSolution">
              <button className="boton" onClick={this.mostrarSolucion}> {textoBotonSolucion} </button>
          </div>

          <div className="buttonSolutionCell">
              <button className="botonCell" onClick={this.descubrirCelda}> {textoBotonCelda} </button>
          </div>
          
        </div>
    );
  }
}

export default Game;