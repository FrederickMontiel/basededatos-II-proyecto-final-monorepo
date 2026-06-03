import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany } from 'typeorm';
import { TipoCliente } from './tipo-cliente.entity';
import { Contacto } from './contacto.entity';
import { Oportunidad } from './oportunidad.entity';
import { Actividad } from './actividad.entity';

@Entity('cliente')
export class Cliente {
  @PrimaryGeneratedColumn()
  id_cliente: number;

  @Column()
  id_tipo_cliente: number;

  @Column({ length: 30, unique: true })
  codigo_cliente: string;

  @Column({ length: 150 })
  nombre_comercial: string;

  @Column({ length: 255, nullable: true })
  direccion_empresa: string;

  @Column({ length: 25, nullable: true })
  telefono: string;

  @Column({ length: 25, nullable: true })
  celular: string;

  @Column({ length: 120, nullable: true })
  correo_electronico: string;

  @Column({ default: true })
  estado: boolean;

  @Column({ type: 'datetime2', default: () => 'SYSDATETIME()' })
  fecha_creacion: Date;

  @ManyToOne(() => TipoCliente, (tipo) => tipo.clientes)
  tipo: TipoCliente;

  @OneToMany(() => Contacto, (contacto) => contacto.cliente)
  contactos: Contacto[];

  @OneToMany(() => Oportunidad, (oportunidad) => oportunidad.cliente)
  oportunidades: Oportunidad[];

  @OneToMany(() => Actividad, (actividad) => actividad.cliente)
  actividades: Actividad[];
}
