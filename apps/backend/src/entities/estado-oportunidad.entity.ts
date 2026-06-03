import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Oportunidad } from './oportunidad.entity';

@Entity('estado_oportunidad')
export class EstadoOportunidad {
  @PrimaryGeneratedColumn()
  id_estado_oportunidad: number;

  @Column({ length: 50 })
  nombre_estado: string;

  @Column({ length: 255, nullable: true })
  descripcion: string;

  @Column({ default: true })
  estado: boolean;

  @OneToMany(() => Oportunidad, (oportunidad) => oportunidad.estado)
  oportunidades: Oportunidad[];
}
