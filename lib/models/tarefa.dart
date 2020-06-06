class Tarefa {
  String id;
  String nome;
  String usuarioId;
  bool concluida;

  Tarefa(this.id, this.nome, this.usuarioId, this.concluida);

  Tarefa.fromJson(Map<String, dynamic> json) { 
    this.id = json['id'];
    this.nome = json['nome'];
    this.usuarioId = json['usuarioId'];
    this.concluida = json['concluida'];
  }

  Map<String, dynamic> toJson() { 
    return {
      "id": this.id,
      "nome" : this.nome,
      "concluida" : this.concluida
    };
  }
}