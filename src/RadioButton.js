import React from 'react';

class RadioButton extends React.Component{
    render(){
        return(
                <div className="radio">
                    <label>
                        <input
                            type="radio"
                            value={this.props.value}
                            checked={this.props.checked}
                            onChange={this.props.onChange}
                        />
                        {this.props.contenido}
                    </label>
                </div>
        );
    }
}

export default RadioButton;