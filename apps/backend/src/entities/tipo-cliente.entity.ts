import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Cliente } from './cliente.entity';

@Entity('tipo_cliente')
export class TipoCliente {
  @PrimaryGeneratedColumn()
  id_tipo_cliente: number;

  @Column({ length: 50 })
  nombre_tipo: string;

  @Column({ length: 255, nullable: true })
  descripcion: string;

  @Column({ default: true })
  estado: boolean;

  @OneToMany(() => Cliente, (cliente) => cliente.tipo)
  clientes: Cliente[];
}
