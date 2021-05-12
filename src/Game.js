import React from 'react';
import PengineClient from './PengineClient';
import Board from './Board';
import RadioButton from './RadioButton';

class Game extends React.Component {

  pengine;

  constructor(props) {
    super(props);
    this.state = {
      grid: null,
      rowClues: null,
      colClues: null,
      waiting: false,
      opcion: '#',
      satisfaccion_filas: [],
      satisfaccion_cols: []
    };
    this.onValueChange = this.onValueChange.bind(this);
    this.handleClick = this.handleClick.bind(this);
    this.handlePengineCreate = this.handlePengineCreate.bind(this);
    this.pengine = new PengineClient(this.handlePengineCreate);
  }

  handlePengineCreate() {
    const queryS = 'init(PistasFilas, PistasColumns, Grilla)';
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          grid: response['Grilla'],
          rowClues: response['PistasFilas'],
          colClues: response['PistasColumns'],
        });
        for(let i=0; i<this.state.grid.length; i++){
          this.state.satisfaccion_filas[i] = 0;
          this.state.satisfaccion_cols[i] = 0;
        }
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
    
    const squaresS = JSON.stringify(this.state.grid).replaceAll('"_"', '"F"')

    let pistas_filas = this.formatear_pista(this.state.rowClues);
    let pistas_columnas = this.formatear_pista(this.state.colClues);

    const queryS = 'put("' + this.state.opcion + '", [' + i + ',' + j + ']' 
    + ', ' + pistas_filas + ', ' + pistas_columnas + ',' + squaresS + ', GrillaRes, FilaSat, ColSat)';

    console.log(queryS);

    this.setState({
      waiting: true
    });
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        //let grilla =  response['GrillaRes'];
        this.setState({
          //grid: JSON.stringify(grilla).replaceAll('"F"', "_"),
          grid: response['GrillaRes'],
          waiting: false
        });

        this.state.satisfaccion_filas[i] = response['FilaSat'];
        this.state.satisfaccion_cols[i] = response['ColSat'];
        console.log(response['FilaSat']);
        console.log(response['ColSat']);

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

  render() {
    if (this.state.grid === null) {
      return null;
    }
    const statusText = 'Keep playing!';
    return (
      <div className="game">
        <Board
          grid={this.state.grid}
          rowClues={this.state.rowClues}
          colClues={this.state.colClues}
          onClick={(i, j) => this.handleClick(i,j)}

          satisfaccion_filas = {this.state.satisfaccion_filas}
          satisfaccion_cols = {this.state.satisfaccion_cols}
        />
        <div className="gameInfo">
          {statusText}
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
            contenido = "#"
          />
        </div>
      </div>
    );
  }
}

export default Game;
